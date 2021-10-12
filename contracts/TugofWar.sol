// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TugofWar {
    uint256 public playTime;
    address internal admin;
    uint256 public version;
    
    mapping( uint256 => mapping( address => int256 )) public yourPosition;
    mapping( uint256 => int256 ) public score;
    mapping( uint256 => uint256 ) private left;
    mapping( uint256 => uint256 ) private right;
    
    modifier payTheFees() { 
        require (msg.value == 1 * 10 ** 18);
        _; 
    }
    
    constructor(){
        version=0;
        playTime = 30 days;
        admin=msg.sender;
      }
    
    function pullRight () external  payable payTheFees {
        yourPosition[version][msg.sender]+=int256(msg.value);
        score[version]++;
        right[version]+=msg.value;
      }
    
    function pullLeft () external payable payTheFees {
        yourPosition[version][msg.sender]-=int256(msg.value);
        score[version]--;
        left[version]+=msg.value;
      }
      
    function withdraw (uint256 _version) external returns(bool){
        require(version != _version);
        if (score[_version]>0){
        uint256 amount = abs(yourPosition[_version][msg.sender])+(left[_version]*abs(yourPosition[_version][msg.sender])/right[_version]);
        if (amount > 0) {
            yourPosition[_version][msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                yourPosition[_version][msg.sender] = int256(amount);
                return false;
            }
        }
        return true;
            
        }
        else if(score[_version]<0){
        uint256 amount = abs(yourPosition[_version][msg.sender])+(right[_version]*abs(yourPosition[_version][msg.sender])/left[_version]);
        if (amount > 0) {
            yourPosition[_version][msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                yourPosition[_version][msg.sender] = int256(amount);
                return false;
            }
        }
        return true;
            
        }
        else{
        uint256 amount = abs(yourPosition[_version][msg.sender]);
        if (amount > 0) {
            yourPosition[_version][msg.sender] = 0;
            if (!payable(msg.sender).send(amount)) {
                yourPosition[_version][msg.sender] = int256(amount);
                return false;
            }
        }
        return true;
            
        }
        
      }
      
    function reset() external {
        require(msg.sender==admin);
        version++;
    }
    
    function winning(uint256 _version) public view returns(int256) {
        if (score[_version]>0){
            return 1;
        }
        else if(score[_version]<0){
            return -1;
        }
        else{
            return 0;
        }
    }
     
    function checkContractBal() external view returns(uint256) {
        return address(this).balance;
    }
     
    function abs (int256 _integer256) private pure returns (uint256) {
        if(_integer256<0){
            return uint256(_integer256*(-1));
        }
        else{
            return uint256(_integer256);
        }
    }
}
