pragma solidity ^0.4.4;


contract Notebook {
  address owner;

  //Array string where the notes will be saved
  string[] titles;
  string[] messages;
  address[] authors;

  //We map the addresses with a value if they have access
  mapping (address => bool) readOnlyAccess;
  mapping (address => bool) fullAccess;

  //Check if they have access
  function isReadOnlyUser(address _addr) constant returns (bool) {
    return readOnlyAccess[_addr];
  }

  function isFullAccessUser(address _addr) constant returns (bool) {
    return fullAccess[_addr];
  }


  //Decorators for checking access
  modifier readOnlyAccessMod(address _addr) {
    if(_addr == owner) _;
    else if( isReadOnlyUser(_addr)) _;
    else revert();
  }

  modifier fullAccessMod(address _addr) {
    if(_addr == owner) _;
    else if( isFullAccessUser(_addr)) _;
    else revert();
  }

  modifier isOwnerMod( address _addr) {
    if(_addr == owner) _;
    else revert();
  }


//Adding access
  function addReadAccess( address _addr) fullAccessMod(msg.sender) {
    readOnlyAccess[_addr] = true;
  }

  function addFullAccess( address _addr) fullAccessMod(msg.sender) {
    fullAccess[_addr] = true;
    readOnlyAccess[_addr] = true;
  }


  //Erasing access. Only owner can erase full access
  function eraseReadAccess( address _addr) fullAccessMod(msg.sender) {
    readOnlyAccess[_addr] = false;
  }

  function eraseFullAccess( address _addr) isOwnerMod(msg.sender) {
    fullAccess[_addr] = false;
  }


  //Function to get the current user status string
  function checkUser( address _addr) constant returns (string) {
    if(_addr == owner) return "The owner!";
    else if(isFullAccessUser(_addr)) return "Full access user";
    else if(isReadOnlyUser(_addr)) return "Read only access user";
    else return "You have no access";
  }


  //Contract constructor
  function Notebook() {
    owner = msg.sender;
  }


    //CRUD operations with notes
    function getNumberOfNotes() readOnlyAccessMod(msg.sender) constant returns (uint) {
      return titles.length;
    }

    function addTitle(string t) fullAccessMod(msg.sender) returns (bool success) {
      titles.length++;
      titles[titles.length-1] = t;
      return true;
    }
    function addMessage(string m) fullAccessMod(msg.sender) returns (bool success) {
      messages.length++;
      messages[messages.length-1] = m;
      return true;
    }
    function addAuthor() fullAccessMod(msg.sender) returns (bool success) {
      authors.length++;
      authors[messages.length-1] = msg.sender;
      return true;
    }

    function deleteNote(uint index) fullAccessMod(msg.sender) returns(bool success) {
      require(index >= 0 && index  < titles.length);

      for(uint i = index; i < titles.length-1 ; i++){
        titles[i] = titles[i+1];
        messages[i] = messages[i+1];
        authors[i] = authors[i+1];
      }

        delete titles[titles.length-1];
        titles.length--;
        delete messages[messages.length-1];
        messages.length--;
        delete authors[authors.length-1];
        authors.length--;
        return true;

        if(titles.length < 0) {
          titles.length = 0;
          messages.length = 0;
          authors.length = 0;
        }
    }

    function editNote(uint index, string t, string m) fullAccessMod(msg.sender) returns (bool success) {
      require(index >= 0 && index  < titles.length);

      titles[index] = t;
      messages[index] = m;
      authors[index] = msg.sender;

      return true;
    }

    function getNoteTitle(uint index) readOnlyAccessMod(msg.sender) constant returns (string) {
      require(index >= 0 && index  < titles.length);

      return titles[index];
    }
    function getNoteMessage(uint index) readOnlyAccessMod(msg.sender) constant returns (string) {
      require(index >= 0 && index  < titles.length);

      return messages[index];
    }
    function getNoteAuthor(uint index) readOnlyAccessMod(msg.sender) constant returns (address) {
      require(index >= 0 && index  < titles.length);
      return authors[index];
    }

}

/*
//The contract a single note
contract Note {
  string title;
  string note;
  address author;

  function Note(string t, string n, address a) {
    editNote(t, n, a);
  }

  function getTitle() constant returns (bytes32 result){
    string memory t = title;
    assembly {
        result := mload(add(t, 32))
    }
  }

  function getNote() constant returns (bytes32 result){
    string memory n = note;
    assembly {
        result := mload(add(n, 32))
    }
  }

  function getAuthor() constant returns (bytes32 result){
    address a = author;
    assembly {
        result := mload(add(a, 32))
    }
  }

  function editNote(string t, string n, address a) {
    title = t;
    note = n;
    author = a;
  }
}

*/
