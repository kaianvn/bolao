(function() {
  function parseScore(value) {
    var parsed = parseInt($.trim(value), 10);
    return isNaN(parsed) || parsed < 0 ? null : parsed;
  }

  function ensureTeam(statsByGroup, groupName, teamId, teamName) {
    if (!statsByGroup[groupName]) {
      statsByGroup[groupName] = {};
    }

    if (!statsByGroup[groupName][teamId]) {
      statsByGroup[groupName][teamId] = {
        id: teamId,
        name: teamName,
        points: 0,
        goalDifference: 0,
        goalsFor: 0
      };
    }
  }

  function addResult(team, goalsFor, goalsAgainst, points) {
    team.goalsFor += goalsFor;
    team.goalDifference += (goalsFor - goalsAgainst);
    team.points += points;
  }

  function recalculateStandings() {
    var statsByGroup = {};

    $('.js-group-stage .js-group-match').each(function() {
      var $row = $(this);
      var groupName = String($row.data('group'));
      var teamAId = String($row.data('team-a-id'));
      var teamAName = String($row.data('team-a-name'));
      var teamBId = String($row.data('team-b-id'));
      var teamBName = String($row.data('team-b-name'));

      ensureTeam(statsByGroup, groupName, teamAId, teamAName);
      ensureTeam(statsByGroup, groupName, teamBId, teamBName);

      var goalsA = parseScore($row.find('.js-goals-a').val());
      var goalsB = parseScore($row.find('.js-goals-b').val());

      if (goalsA === null || goalsB === null) {
        return;
      }

      if (goalsA > goalsB) {
        addResult(statsByGroup[groupName][teamAId], goalsA, goalsB, 3);
        addResult(statsByGroup[groupName][teamBId], goalsB, goalsA, 0);
      } else if (goalsB > goalsA) {
        addResult(statsByGroup[groupName][teamAId], goalsA, goalsB, 0);
        addResult(statsByGroup[groupName][teamBId], goalsB, goalsA, 3);
      } else {
        addResult(statsByGroup[groupName][teamAId], goalsA, goalsB, 1);
        addResult(statsByGroup[groupName][teamBId], goalsB, goalsA, 1);
      }
    });

    $('.js-standings-body').each(function() {
      var $tbody = $(this);
      var groupName = String($tbody.data('group'));
      var teamsHash = statsByGroup[groupName] || {};
      var teams = [];

      $.each(teamsHash, function(_, team) {
        teams.push(team);
      });

      teams.sort(function(a, b) {
        if (b.points !== a.points) return b.points - a.points;
        if (b.goalDifference !== a.goalDifference) return b.goalDifference - a.goalDifference;
        if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;
        return a.name.localeCompare(b.name);
      });

      var rows = '';
      for (var i = 0; i < teams.length; i++) {
        rows += '<tr>' +
          '<td>' + teams[i].name + '</td>' +
          '<td class="center">' + teams[i].points + '</td>' +
          '<td class="center">' + teams[i].goalDifference + '</td>' +
          '<td class="center">' + teams[i].goalsFor + '</td>' +
          '</tr>';
      }

      $tbody.html(rows);
    });
  }

  function initLiveStandings() {
    if (!$('.js-group-stage').length) {
      return;
    }

    $(document)
      .off('input.liveStandings keyup.liveStandings change.liveStandings', '.js-group-stage .js-goals-a, .js-group-stage .js-goals-b')
      .on('input.liveStandings keyup.liveStandings change.liveStandings', '.js-group-stage .js-goals-a, .js-group-stage .js-goals-b', recalculateStandings);

    recalculateStandings();
  }

  $(document).on('ready page:load', initLiveStandings);
})();
