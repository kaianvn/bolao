(function() {
  function maybeSetAdvancing($row) {
    var $goalsA = $row.find('.js-goals-a');
    var $goalsB = $row.find('.js-goals-b');
    var $adv = $row.find('.js-advancing');
    if (!$adv.length) return;

    var a = parseInt($.trim($goalsA.val()), 10);
    var b = parseInt($.trim($goalsB.val()), 10);
    if (isNaN(a) || isNaN(b)) return;

    if (a > b) {
      // pick team A
      var teamAId = $row.data('team-a-id');
      $adv.val(String(teamAId));
    } else if (b > a) {
      var teamBId = $row.data('team-b-id');
      $adv.val(String(teamBId));
    } else {
      // draw, don't change (keep user's explicit selection)
    }
  }

  function wireAutoAdvancing() {
    $(document).on('input', '.js-goals-a, .js-goals-b', function() {
      var $row = $(this).closest('tr.js-group-match, tr');
      maybeSetAdvancing($row);
    });
  }

  function showKnockoutValidationAlert(message) {
    var $alert = $('#knockout-missing-advance-alert');
    if (!$alert.length) return;

    $alert.text(message).removeClass('hide');
  }

  function clearKnockoutValidationAlert() {
    var $alert = $('#knockout-missing-advance-alert');
    if (!$alert.length) return;

    $alert.addClass('hide').text('');
  }

  function validateKnockoutBeforeSubmit() {
    var $form = $('form[action$="/palpites"]');
    if (!$form.length) return;

    $form.off('submit.knockoutValidation').on('submit.knockoutValidation', function(event) {
      var hasIssue = false;
      var message = 'Ainda falta preencher quem avança em pelo menos um empate do mata-mata.';

      $('.js-knockout-match').each(function() {
        var $row = $(this);
        var $goalsA = $row.find('.js-goals-a');
        var $goalsB = $row.find('.js-goals-b');
        var $adv = $row.find('.js-advancing');
        var a = parseInt($.trim($goalsA.val()), 10);
        var b = parseInt($.trim($goalsB.val()), 10);

        $row.removeClass('danger');

        if (isNaN(a) || isNaN(b)) {
          return;
        }

        if (a === b && !$adv.val()) {
          hasIssue = true;
          $row.addClass('danger');
        }
      });

      if (hasIssue) {
        event.preventDefault();
        showKnockoutValidationAlert(message);
        var $firstProblem = $('.js-knockout-match.danger').first();
        if ($firstProblem.length) {
          $('html, body').animate({ scrollTop: $firstProblem.offset().top - 120 }, 250);
        }
      } else {
        clearKnockoutValidationAlert();
      }
    });
  }

  $(document).on('ready page:load', function() {
    wireAutoAdvancing();
    validateKnockoutBeforeSubmit();
    // run initial pass to auto-fill advancing where possible from prefilled values
    $('.js-group-match, .js-knockout-match').each(function() {
      maybeSetAdvancing($(this));
    });
  });
})();
