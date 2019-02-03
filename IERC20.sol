interface IERC20 {
    //funciones basicas
    function totalSupply() external returns(uint256);
    
    function balanceOf(address sujeto) external returns(uint256);
    
        
    //funciones para transferencia
    function transfer (address destinatario, uint256 value) external returns (bool);
    
    function transferFrom(address enviador, address destinatario, uint256 value) external returns (bool);
    
    
    //funciones para exchange
    function approve(address autorizado, uint256 cantidad) external returns (bool);
    
    function allowance (address propietario, address autorizado) external view returns (uint256);
    
    
    //eventos
    event Transfer (address remitente, address destinatario, uint256 cantidad);
    
    event Approval (address indexed propietario, address indexed autorizado, uint256 cantidad);
}