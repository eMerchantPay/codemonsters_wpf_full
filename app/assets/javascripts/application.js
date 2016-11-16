// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require jquery.card.latest
//= require cable
//= require_self


function applyCard() {
  $('form').card({
    container: '.card-wrapper',

    formSelectors: {
      numberInput: '#card_number',
      expiryInput: '#expiration_date',
      nameInput: '#card_holder',
      cvcInput: '#cvv'
    }
  });
}

function listenForFormSubmitEvent() {
  $('form').on('submit', function(e) {
    e.preventDefault();

    $(this).slideUp(function(){
      infoMessage('Please wait...').fadeIn();
      fadeOutImages();
      disablePay();

      setTimeout(function(){
        $.post('/wpf_form/sale', $('form').serialize())
          .success(function(data) {

            if (data.http_code === "200" && data.status === "approved") {
              successMessage(data.message);
              showSuccessImage();

              addTransactionIdInput(data.unique_id);
              showVoid();
              removePay();
            }else{
              errorMessage('').append(errors(data));
              showErrorImage();
              enableTryAgain();
            }
          }).error(onServerError);
      }, 2000);
    });
  });

}

function listenForSubmitButtonClick() {
  $('#submit').click(function(){
    $('form').submit();
  });
}

function listenForTryAgainButtonClick() {
  $('#restart').click(function(){
    removeTryAgain();

    showForm();
  });
}

function listenForCancelButtonClick() {
  $('#cancel').click(function(){
    $(location).attr('href', '/');
  });
}

function createVoidTransaction() {
  $.post('/wpf_form/void', $('form').serialize())
    .success(function(data) {
      if (data.http_code === "200") {
        successMessage(data.message);
        showSuccessImage();

        removeVoid();
      } else {
        errorMessage('Your void was not successful!');
        showErrorImage();
        enableVoid();
      }
    }).error(onServerError);
}

function listenForVoidButtonClick() {
  $('#void').click(function(){
    infoMessage('Please wait...');
    fadeOutImages();
    disableVoid();

    setTimeout(function() {
      createVoidTransaction();
    }, 2000);
  });
}

// Handlers

function onServerError() {
  errorMessage('Something went wrong!');

  showErrorImage();
}

// Helpers

function showForm() {
  fadeOutImages();

  $('.message').fadeOut(function() {
    $('.error_image').fadeOut();
    $('form').slideDown(function() {
      $('#submit').prop("disabled", "");
    });
  });
}

function fadeOutImages() {
  $('.error_image').fadeOut();
  $('.success_image').fadeOut();
}

function showErrorImage() {
  $('.error_image').show();
}

function showSuccessImage() {
  $('.success_image').show();
}

function disablePay() {
  $('#submit').prop("disabled", "disabled");
}

function removePay() {
  $('#submit').slideUp();
}

function showVoid() {
  $('#void').delay(500).slideDown();
}

function disableVoid() {
  $('#void').prop("disabled", "disabled");
}

function enableVoid() {
  $('#void').prop("disabled", "");
}

function removeVoid() {
  $('#void').slideUp();
}

function enableTryAgain() {
  $('#restart').delay(500).slideDown();
}

function removeTryAgain() {
  $('#restart').slideUp();
}

function addTransactionIdInput(id) {
  var $input = $('<input/>', {
    value: id,
    name: 'unique_id',
    type: 'hidden'
  });

  $('form').append($input);
}

// Messages

function infoMessage(message) {
  return $('.message')
            .text(message)
            .addClass('alert-info')
            .removeClass('alert-success')
            .removeClass('alert-danger');
}

function successMessage(message) {
  return $('.message')
            .text(message)
            .addClass('alert-success')
            .removeClass('alert-danger')
            .removeClass('alert-info');
}

function errorMessage(message) {
  return $('.message')
            .text(message)
            .addClass('alert-danger')
            .removeClass('alert-info')
            .removeClass('alert-success');
}

// Errors

function errors(data) {
  var $list = $('<ul></ul>');

  $.each(data, function(key, message) {
    if(message.constructor === Array) {
      var errors = '';

      $.each(message, function(key, error) {
        errors += error+'; ';
      });

      $('<li></li>').text(key + ': ' + errors).appendTo($list);
    }
  });

  return $('<div></div>').text(data.message).append($list);
}

// Run Application

$(function() {
  applyCard();
  listenForFormSubmitEvent();
  listenForSubmitButtonClick();
  listenForTryAgainButtonClick();
  listenForCancelButtonClick();
  listenForVoidButtonClick();
});
