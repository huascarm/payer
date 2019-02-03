
contract Payer is IERC20{
    
    using MatematicaSegura for uint256;
    
    // variables del contrato
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    address public _propietario;
    uint256 private _totalSupply;

    mapping (address => bool) public _administradores;
    mapping (address => bool) public notransferible;
    mapping (address => uint256) private balance;
    mapping (address => mapping (address => uint256)) public _autorizado;
    
    //caracteristicas de la moneda
    uint256 public decimals = 8;
    string public name = "Payer";
    string public symbol = "MC";
    
    constructor(uint256 totalSupply) public {
        _totalSupply = totalSupply;
        _propietario = msg.sender;
        balance[_propietario] = totalSupply;
        _administradores[_propietario] = true;
    }
   
    //funciones propias
    modifier OnlyOwner(){
        require(msg.sender == _propietario, "No es el propietario");
        _;
    }
    function isAdmin(address direccion) public view OnlyOwner returns(bool){
        return _administradores[direccion];
    }
    function setNewAdmin(address postulante) private OnlyOwner returns(bool){
        require(postulante != address(0), "Dirección No Válida");
        _administradores[postulante] = true;
    }
    
    function setTransferible(address admin, address sujeto, bool state) public returns (bool) {
        require(_administradores[admin], "Dirección no autorizada");
        notransferible[sujeto] = state;
        return true;
    }
    // funciones basicas
    function totalSupply() public returns(uint256){
        return _totalSupply;
    }
    
    function balanceOf(address sujeto) public returns (uint256){
        require(sujeto != address(0),"Dirección No Válida");
        return balance[sujeto];
    }

    //funciones de transferencia
    function transfer(address destinatario, uint256 cantidad) public returns(bool){
        _transfer(msg.sender, destinatario, cantidad);
        return true;
    }
    function transferFrom(address remitente, address destinatario, uint256 cantidad) public returns(bool){
        _transfer(remitente, destinatario, cantidad);
        return true;
    }
    function _transfer (address remitente, address destinatario, uint256 cantidad) internal{
        require(!notransferible[remitente], "Dirección bloqueada temporalmente");
        require(destinatario != address(0), "Dirección No Válida");
        require(remitente != address(0), "Dirección No Válida");
        balance[remitente] = balance[remitente].restar(cantidad);
        balance[destinatario] = balance[destinatario].sumar(cantidad);
        emit Transfer(remitente, destinatario, cantidad);
    }

    //funciones para exchange
    //** Muestra la cantidad de monedas que esta permitido transferir el autorizado*/
    function allowance (address propietario, address autorizado) public view returns(uint256){
        return _autorizado[propietario][autorizado];
    }
    /** funcion que autoriza la nueva cantidad a transferir */
    function approve( address autorizado, uint256 cantidad) public returns(bool) {
        _approve(msg.sender, autorizado, cantidad);
        return true;
    }
    
    function _approve (address propietario, address autorizado, uint256 cantidad) internal {
        require (propietario != address(0), "Dirección No Válida");
        require (autorizado != address(0), "Dirección No Válida");

        _autorizado[propietario][autorizado] = cantidad;
        emit Approval(propietario, autorizado, cantidad);
    }

    function increaseAllowance (uint256 adicional, address autorizado) private OnlyOwner returns (bool){
        require(autorizado != address(0), "Dirección No Válida");
        _autorizado[msg.sender][autorizado] = _autorizado[msg.sender][autorizado].sumar(adicional);
        emit Approval(msg.sender, autorizado, adicional);
        return true;
    }
    function decreaseAllowance (uint256 reduccion, address autorizado) private OnlyOwner returns (bool){
        require(autorizado != address(0), "Dirección No Válida");
        _autorizado[msg.sender][autorizado] = _autorizado[msg.sender][autorizado].restar(reduccion);
        emit Approval(msg.sender, autorizado, reduccion);
        return true;
    }
    function burn(address cuenta, uint256 cantidad) internal{
        require(cuenta != address(0), "Dirección No Válida");
        require(balance[cuenta] >= cantidad, "Saldo insuficiente para quemar");
        balance[cuenta] = balance[cuenta].restar(cantidad);
        _totalSupply = _totalSupply.restar(cantidad);
        emit Transfer(cuenta, address(0), cantidad);
    }
    function burnFrom(address cuenta, uint256 cantidad) internal{
        require (cuenta != address(0), "Dirección No Valida");
        require (_autorizado[cuenta][msg.sender] >= cantidad, "Saldo insuficiente para quemar");
        _autorizado[cuenta][msg.sender] = _autorizado[cuenta][msg.sender].restar(cantidad);
        burn(cuenta, cantidad);
    }

    event Transfer(address enviante, address destinatario, uint256 cantidad);
    event Approval(address propietario, address autorizado, uint256 cantidad);

}