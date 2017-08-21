pragma solidity ^0.4.4;


contract Notebook {
  address owner;
  //Array string where the notes will be saved
  Note[] notes;

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
      return notes.length;
    }

    function addNote(string title, string note) fullAccessMod(msg.sender) returns (bool success) {
      notes.push(new Note(title, note, msg.sender));
      return true;
    }

    function deleteNote(uint index) fullAccessMod(msg.sender) returns(bool success) {
      require(index >= 0 && index  < notes.length);

      for(uint i = index; i < notes.length-1 ; i++)
        notes[i] = notes[i+1];

        delete notes[notes.length-1];
        notes.length--;
        return true;

        if(notes.length < 0) notes.length = 0;
    }

    function editNote(uint index, string title, string note) fullAccessMod(msg.sender) returns (bool success) {
      require(index >= 0 && index  < notes.length);
      notes[index].editNote(title, note, msg.sender);

      return true;
    }

    function getNote(uint index) readOnlyAccessMod(msg.sender) constant returns (Note) {
      return notes[index];
    }
}
//The contract a single note
contract Note {
  string title;
  string note;
  address author;

  function Note(string t, string n, address a) {
    editNote(t, n, a);
  }

  function editNote(string t, string n, address a) {
    title = t;
    note = n;
    author = a;
  }
}
