/* Only selection IDs are handled here. All scoring happens in C#. */
(function () {
    "use strict";
    var field = document.getElementById("hfSelected");
    var buttons = document.querySelectorAll("#quizMessage [data-part-id]");
    if (!field) {
        return;
    }
    var selected = field.value ? field.value.split(",") : [];
    function refresh() {
        for (var i = 0; i < buttons.length; i++) {
            var active = selected.indexOf(buttons[i].getAttribute("data-part-id")) !== -1;
            buttons[i].classList.toggle("quiz-selected", active);
            buttons[i].setAttribute("aria-pressed", active ? "true" : "false");
        }
        field.value = selected.join(",");
        var count = document.getElementById("quizSelectionCount");
        if (count) count.textContent = selected.length + " parts selected.";
    }
    for (var i = 0; i < buttons.length; i++) {
        buttons[i].addEventListener("click", function () {
            var id = this.getAttribute("data-part-id");
            var position = selected.indexOf(id);
            if (position === -1) {
                selected.push(id);
            } else {
                selected.splice(position, 1);
            }
            refresh();
        });
    }
    refresh();
    window.quizValidateParts = function (source, args) {
        args.IsValid = field.value.length > 0;
    };
}());
