var codeToRemove = null;
$(document).ready(function() {
    $(".draggable").draggable({
      cursor: 'move',
      helper: 'clone',
      opacity: 0.85,
      connectToSortable : "#source",
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
              if (command[1] == '_') {
                command = command.substring(2,command.length);
              }
              program += command + "\n";
              $("#source").append("<div id='" + i + "_" + command + "' class='" + command + "'>" + command + "</div>");
            }
          }
          code = $("#source").sortable("toArray");
          if (code.length == 0) {
              $("#source").append("<div id='placeholder'>Drop Code Here</div>");
          }
          $("#code textarea").val(program);
          codeToRemove = null;
        }
      };
    };
    $("#source").sortable(sortable_options());
});
