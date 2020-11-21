pragma solidity ^0.5.1;

contract Challenge7{
    
    function messageHash(address _reciver , uint _amt , string memory _msg , uint _nonce) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(_reciver , _amt , _msg , _nonce));
    }
    
    function MsgHashSignedEth(bytes32  _hashedMsg) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hashedMsg));
        
    }
    
    
    function Verification(address _signerOfMsg , address _reciver , uint _amt , string memory _msg , uint _nonce , bytes memory _Sign ) public pure returns(bool)
    {
        bytes32 Msg_Hash = messageHash(_reciver , _amt , _msg , _nonce);
        bytes32 eth_Signed_Msg = MsgHashSignedEth(Msg_Hash);
        
        return Recover_Msg_Signer(eth_Signed_Msg , _Sign) == _signerOfMsg;
    }
    
    function Recover_Msg_Signer(bytes32 eth_Signed_Msg , bytes memory _Sign) public pure returns(address)
    {
        (bytes32 r , bytes32 s , uint8 v) = Split_Sign(_Sign);
        return ecrecover(eth_Signed_Msg , v ,r ,s);
    }
    
    function Split_Sign(bytes memory _Sig) public pure returns(bytes32 R ,bytes32 S , uint8 V)
    {
        require(_Sig.length == 65, "Invalid Signautre Length");
        assembly {
            R := mload(add(_Sig,32))
            S := mload(add(_Sig,64))
            V := byte(0, mload(add(_Sig,96)))
            
        }
    }
}