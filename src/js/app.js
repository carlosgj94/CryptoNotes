App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load notes.
    /*$.getJSON('../pets.json', function(data) {
      var notesRow = $('#notesRow');
      var noteTemplate = $('#noteTemplate');

      for (i = 0; i < data.length; i ++) {
        noteTemplate.find('.panel-title').text(data[i].name);
        noteTemplate.find('.note-message').text(data[i].breed);
        noteTemplate.find('.note-author').text(data[i].age);

        notesRow.append(petTemplate.html());
      }
    });*/

    return App.initWeb3();
  },

  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Notebook.json', function(data) {
      var NotebookArtifact = data;
      App.contracts.Notebook = TruffleContract(NotebookArtifact);

      // Set the provider for our contract.
      App.contracts.Notebook.setProvider(App.web3Provider);
      return App.retriveNotes();
    });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-delete', function(e){
      App.handleDelete(e.target.id);
    });
    $(document).on('click', '.btn-add', App.newNote);
  },

  handleDelete: function(noteId) {
    //event.preventDefault();

    //var noteId = parseInt($(event.target).data('id'));
    web3.eth.getAccounts(function(error, accounts) {
      if(error) {
        console.log(error);
      }

      var account = accounts[0];
    console.log(noteId);
    App.contracts.Notebook.deployed().then(function(instance) {
      notebooksInstance = instance;
      return notebooksInstance.deleteNote(noteId, {from: account});
    }).then(function (){
      App.retriveNotes();
    }).catch(function(err) {
      console.log(err.message);
    });
  });
},

  retriveNotes: function() {
    var notebooksInstance;

    App.contracts.Notebook.deployed().then(function(instance) {
      notebooksInstance = instance;
      return notebooksInstance.getNumberOfNotes();
    }).then(function (notesNumber){
      notesNumber = notesNumber.c[0];
      console.log(notesNumber);
      for(var i=0; i<notesNumber; i++)
        App.printNote(notebooksInstance.getNoteTitle(i),
        notebooksInstance.getNoteMessage(i),
        notebooksInstance.getNoteAuthor(i));
    });

  },

  printNote: function(title, message, author) {
    var notesRow = $('#notesRow');
    var noteTemplate = $('#noteTemplate');

    title.then(function (_title) {
      message.then(function (_message) {
        author.then(function (_author) {
          noteTemplate.find('.panel-title').text(_title);
          noteTemplate.find('.note-message').text(_message);
          noteTemplate.find('.note-author').text(_author);
          notesRow.append(noteTemplate.html());
        });
      });
    });
  },


  newNote: function() {

    web3.eth.getAccounts(function(error, accounts) {
      if(error) {
        console.log(error);
      }

      var account = accounts[0];
      console.log(web3.eth.getBalance(account));
      App.contracts.Notebook.deployed().then(function(instance) {
        notebooksInstance = instance;
        return notebooksInstance.addTitle("adsjfns", {from: account});
      }).then(function (_title){
        console.log(_title);
        return notebooksInstance.addMessage("r4inr f4 3 3kj 4f", {from: account});
      }).then(function (_message){
        console.log(_message);
        return notebooksInstance.addAuthor({from: account});
      }).then(function (_author){
        console.log(_author);
        return App.retriveNotes();
      }).catch(function(err) {
        console.log(err.message);
      });
    });

  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
