library MatematicaSegura {
    
    function multiplicar (uint256 p, uint256 s) internal pure returns(uint256){
        if(p == 0  || s == 0) return 0;
        uint256 c = p*s;
        require (c/p == s);
        return c;
    }
    
    function dividir (uint256 v, uint256 d) internal pure returns(uint256){
        require(d>0);
        
        uint256 r = v / d;
        require(v == r*d + v % d);
        return r;
    }
    
    function sumar(uint256 s1, uint256 s2) internal pure returns(uint256){
        uint256 r = s1 + s2;
        require ( r >= s1);
        return r;
    }
    
    function restar (uint256 m, uint256 s) internal pure returns(uint256) {
        require (m > s);
        return m-s;
    }
}