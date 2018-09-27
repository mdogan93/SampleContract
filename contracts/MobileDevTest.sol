pragma solidity ^0.4.24;

contract MobileDevTest {
    
    struct AddressData{
        string city;
        string neighborhood;
        uint streetNo;
        uint aptNo;
    }
    
    struct Person{
        bytes32 userID;
        string name;
        uint birth;
        address[] relations;
        AddressData accAddress;
        
    }
    
    modifier hasEnoughMoney(){
        require(msg.value>=0.5 ether);
        _;
    }
    
    modifier isExclusiveMember(){
        require(exclusiveMembers[msg.sender]);
        _;
    }
    
    mapping (address => Person) mapPeople;
    address[] arrPeopleAddr;
    
    mapping(address => uint) ethBalances;
    
    mapping (address => bool) exclusiveMembers;
    
    /*
    "Istanbul", "Kadikoy", 32, 2, "0xf45055786089633ffbfc4e2d20f81e03df23e9bca22a393ff8931dadcef409fa", "Chucky", 1534411595
    "Istanbul", "Kadikoy", 32, 2, "0xcef3d50c2dc2451ea1e21cc4ef97a103", "Chucky", 1534411595
    */
    function addPerson(string _city, string _neighborhood, uint _streetNo, uint _aptNo,
                        bytes32 _userID, string _name, uint _birth) external {
        require(mapPeople[msg.sender].birth==0);
        AddressData memory tempAddr = AddressData(_city,_neighborhood,_streetNo,_aptNo);
        Person storage person = mapPeople[msg.sender];
        person.userID = _userID;
        person.name= _name;
        person.birth=_birth;
        person.accAddress=tempAddr;
        
        arrPeopleAddr.push(msg.sender);
    }
    
    /*
        0x1337c3f3a39ba23228ec31036c5954ab6b9e9885
    */
    
    function getPersonByAddress(address _user) external view returns(bytes32,string,uint,bool){
        Person memory person = mapPeople[_user];
        return (person.userID, person.name, person.birth, exclusiveMembers[_user]);   
    }
    

    /*
        Returns address of msg.sender
    */
    function getAddressOfUser() external view returns(string,string,uint,uint) {
        AddressData memory currAddr = mapPeople[msg.sender].accAddress;
        return (currAddr.city, currAddr.neighborhood, currAddr.streetNo, currAddr.aptNo);
    }
    
    /*
        "Megaman"
    */
    function updatePersonName(string _newName) external {
        mapPeople[msg.sender].name = _newName;
    }
    
    /*
        Returns balance of user
    */
    function getBalanceOf(address user)external view returns(uint){
        return ethBalances[user];
    }
    
    /*
        Refunds to exclusive members
    */
    function withdrawMoney() public{
        uint amount = ethBalances[msg.sender];
        ethBalances[msg.sender] = 0;
        msg.sender.transfer(amount);
    }
    
    /*
        Send at least 0.5 ether to become Exclusive Member
    */
    function beExclusiveMember() external payable hasEnoughMoney {
        exclusiveMembers[msg.sender]=true;
        ethBalances[msg.sender]+=msg.value;
    }
    
    /*
        Only Exclusive members can add relations 
    */
    function addNewRelation(address _to) external isExclusiveMember{
        Person storage exMember = mapPeople[msg.sender];
        exMember.relations.push(_to);
    }
    
    /*
        Returns relations of msg.sender
    */
    function getRelations() external view returns(address[]){
        return mapPeople[msg.sender].relations;
    }
    
    

}