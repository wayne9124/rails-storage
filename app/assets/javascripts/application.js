//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require moment
//= require fullcalendar
//= require fullcalendar/locale-all
//= require_tree .

function eventCalendar() {
  return $('#event_calendar').fullCalendar({
    locale: "zh-tw",
    selectable: true,
    editable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'month',
    height: 500,
    slotMinutes: 30,
    events: "/events.json",
    eventDrop: function( event, delta, revertFunc, jsEvent, ui, view ){
      var id = event.id;

      var start = event.start.format("YYYY-MM-DD hh:mm:ss");
      var end = event.end.format("YYYY-MM-DD hh:mm:ss");
      $.ajax({
        url: "/events/" + id,
        type: "PUT",
        dataType: "json",
        headers: {'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')},
        data:({"event": {
          "start_time": start,
          "end_time":   end
        }
        }),
        error: function(xhr) {
          alert('Ajax request 發生錯誤');
        },
        success: function(response) {
          console.log(response);
            // $('#msg_user_name').html(response);
            // $('#msg_user_name').fadeIn();

        }
      });
    }
  });
};
function clearCalendar() {
  $('#event_calendar').fullCalendar('delete'); // In case delete doesn't work.
  $('#event_calendar').html('');
  console
};
$(document).on('turbolinks:load', eventCalendar);
$(document).on('turbolinks:before-cache', clearCalendar)
