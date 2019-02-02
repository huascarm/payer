pragma solidity ^0.5.1;

import "MatematicaSegura.sol";

contract Payer {
    
    using MatematicaSegura for uint256;
    
    uint256 private _totalSupply;
    mapping (address => uint256) public balance;
    mapping (address => mapping (address => uint256)) public _allowed;
    
    //caracteristicas de la moneda
    uint256 public decimals = 8;
    string public name = "Payer";
    
    constructor(uint256 totalSupply) public {
        _totalSupply = totalSupply;
    }
    
    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    
    function balanceOf(address sujeto) public view returns (uint256){
        require(sujeto != address(0));
        return balance[sujeto];
    }
    
    function allowance (address propietario, address autorizado)  returns(uint256){
        require (propietario != address(0)  && autorizado != address(0));
        return _allowed[propietario][autorizado];
    }
    
    function transfer(address destinatario, uint256 cantidad) public returns(bool){
        require(destinatario != address(0));
        _transfer(msg.sender(), destinatario, cantidad);
        return true;
    }
    
    function approve( address autorizado, uint256 cantidad) public returns(bool) {
        _approve(msg.sender(), autorizado, cantidad);
        return true;
    }
    //**hasta aqui **//
    
    function transferFrom(address enviante, address receptor, uint256 cantidad) public returns(bool){
        
        _transfer(enviante, receptor, cantidad);
        return true;
    }
    
    function _approve (address propietario, address autorizado, uint256 cantidad) internal {
        require ( propietario != address(0));
        require ( autorizado != address(0));
        _allowed[owner][spender] = value;
    }
    
    // funcion nativa que hace la transferencia
    function transfer (address enviante, address destinatario, uint256 cantidad) internal{
        require(destinatario != address(0));
        balance[enviante] = balance[enviante].restar(cantidad);
        balance[destinatario] = balance[destinatario].sumar(cantidad);
        Transfer(enviante, destinatario, cantidad);
    }
    
    event Transfer(address enviante, address destinatario, uint256 cantidad);
    event Approval(enviante, destinatario, cantidad);
}