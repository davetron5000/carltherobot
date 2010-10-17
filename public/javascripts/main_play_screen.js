var codeToRemove = null;
$(document).ready(function() {
    $("#move").simpletip({ content: "Move C.A.R.L. forward one square in the direction he is facing", position: "bottom", showTime: '350'});
    $("#turnleft").simpletip({ content: "Turn C.A.R.L. in place to his left", position: "bottom", });
    $("#pickbeacon").simpletip({ content: "Pick up a beacon at the current position", position: "bottom", });
    $("#putbeacon").simpletip({ content: "Put down a beacon at the current position", position: "bottom", });
    $(".draggable").draggable({
      cursor: 'move',
      helper: 'clone',
      opacity: 0.85,
      connectToSortable : "#source",
        start: function(event,ui) {
          $(".tooltip").css("visibility","hidden");
        },
        stop: function(event,ui) {
          $(".tooltip").css("visibility","visible");
        }
    });
    $(".trash").droppable({
      drop: function(event,ui) {
        codeToRemove = ui.helper.attr("id");
        $(".trash").removeClass("trash-highlight");
      },
      over : function(event,ui) {
        $(".trash").addClass("trash-highlight");
      },
      out : function(event,ui) {
        $(".trash").removeClass("trash-highlight");
      }
    });
    function sortable_options() {
      return {
        cursor: 'move',
        placeholder: 'command-reorder-highlight',
        stop: function(event,ui) {
          var code = $("#source").sortable("toArray");
          $("#source div").remove();
          var program = "";
          for (var i=0; i<code.length; i++) {
            var loc = code[i];
            if ((loc != codeToRemove) && (loc != 'placeholder')) {
              var command = loc;
              var regex = /^[0-9]*_/;
              if (command.match(regex)) {
                var parts = command.split(/_/);
                command = parts[1];
              }
              program += command + "\n";
              var symbol = "";
              if (command == "move") {
                symbol = "&#x2191; "
              }
              else if (command == "turnleft") {
                symbol = "&#x21B0; "
              }
              else if (command == "pickbeacon") {
                symbol = "&#x21F1; "
              }
              else if (command == "putbeacon") {
                symbol = "&#x21F2; "
              }
                

              var command_text = symbol + command;
              $("#source").append("<div id='" + i + "_" + command + "' class='" + command + "'>" + command_text + "</div>");
            }
          }
          code = $("#source").sortable("toArray");
          $(".trash").css("visibility","visible");
          if (code.length == 0) {
              $("#source").append("<div id='placeholder'>Drop Code Here</div>");
              $(".trash").css("visibility","hidden");
          }
          $("#code textarea").val(program);
          var height = $("#program").height();
          if (height > $("#entirepage").height()) {
            $("#entirepage").height(height);
          }
          codeToRemove = null;
        }
      };
    };
    $("#source").sortable(sortable_options());
});
