pragma solidity ^0.4.4;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Notebook.sol";

contract TestNotebook {
  Notebook notebook = Notebook(DeployedAddresses.Notebook());


  function testGetNumberOfNotes(){
    notebook = new Notebook();

    uint256 i = notebook.getNumberOfNotes();
    Assert.equal(i, 0, "Number of notes is not 0.");
  }

  function testCreateNote() {
    notebook.addNote("Hola", "Hello");

    bytes32 title = notebook.getNote(0).getTitle();
    Assert.equal(title, "Hola", "First note incorrect.");
  }

  function testEditNote() {
    notebook.editNote(0, "Ahoj", "Hello");
    bytes32 title = notebook.getNote(0).getTitle();
    Assert.equal(title, "Ahoj", "First note incorrect.");
  }

  function testDeleteNote() {
    notebook.deleteNote(0);
    uint256 i = notebook.getNumberOfNotes();
    Assert.equal(i, 0, "Note not deleted.");
  }
}
