var editNote;

App = {
  web3Provider: null,
  contracts: {},

  init: function() {
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
    $(document).on('click', '.btn-delete', function (event){
      App.handleDelete(event);
    });
    $(document).on('click', '.btn-edit-modal', function (event){
      App.handleEdit(event);
    });
    $(document).on('click', '.btn-edit', App.handleEditModal);
    $(document).on('click', '.btn-add', App.newNote);
  },

//Function called when we press the edit button
  handleEdit: function(event) {
    editNote = parseInt($(event.target).data('id'));
  },
  handleEditModal : function() {
    var _title = $('#note-title-modal').val();
    var _message = $('#note-message-modal').val();
    web3.eth.getAccounts(function(error, accounts) {
      if(error) {
        console.log(error);
      }

    var account = accounts[0];
    App.contracts.Notebook.deployed().then(function(instance) {
      notebooksInstance = instance;
      return notebooksInstance.editNote(editNote, _title, _message, {from: account});
    }).then(function (){
      App.retriveNotes();
    }).catch(function(err) {
      console.log(err.message);
    });
  });
  },

//Function called when we press the delete button
  handleDelete: function(event) {
    var noteId = parseInt($(event.target).data('id'));
    web3.eth.getAccounts(function(error, accounts) {
      if(error) {
        console.log(error);
      }

    var account = accounts[0];
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
      if(notesNumber==0)
        $('#notesRow').empty();
      else
        for(var i=0; i<notesNumber; i++)
          App.printNote(notebooksInstance.getNoteTitle(i),
          notebooksInstance.getNoteMessage(i),
          notebooksInstance.getNoteAuthor(i),
          i);
    });

  },

  printNote: function(title, message, author, id) {
    var notesRow = $('#notesRow');
    var noteTemplate = $('#noteTemplate');

    notesRow.empty();

    title.then(function (_title) {
      message.then(function (_message) {
        author.then(function (_author) {
          noteTemplate.find('.panel-title').text(_title);
          noteTemplate.find('.note-message').text(_message);
          noteTemplate.find('.note-author').text(_author);
          noteTemplate.find('.btn-edit-modal').attr('data-id', id);
          noteTemplate.find('.btn-delete').attr('data-id', id);
          notesRow.append(noteTemplate.html());
        });
      });
    });
  },


  newNote: function() {
    console.log("Hola");
    var _title = $('#note-title').val();
    var _message = $('#note-message').val();
    if(_title != undefined && _message != undefined)
      web3.eth.getAccounts(function(error, accounts) {
        if(error) {
          console.log(error);
        }

        var account = accounts[0];
        console.log("Balance: "+web3.eth.getBalance(account).c);
        App.contracts.Notebook.deployed().then(function(instance) {
          notebooksInstance = instance;
          return notebooksInstance.addTitle(_title, {from: account});
        }).then(function (_title){
          console.log(_title);
          return notebooksInstance.addMessage(_message, {from: account});
        }).then(function (_message){
          console.log(_message);
          return notebooksInstance.addAuthor({from: account});
        }).then(function (_author){
          console.log(_author);
          console.log("Balance: "+web3.eth.getBalance(account).c);
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
