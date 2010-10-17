$(document).ready(function() {
    $(".draggable").draggable({
      cursor: 'move',
      helper: 'clone',
      opacity: 0.85,
    });
    $("#code").droppable({
      drop: function(event, ui) { 
        var command = ui.draggable.attr("id");
        $("#code textarea").val($("#code textarea").val() + "\n" + command);
      }
    });
});
