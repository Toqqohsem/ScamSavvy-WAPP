/* =====================================================================
   Scam Savvy - shared client-side script
   Owner: Member 2. Loaded on every page by Site.Master, after Bootstrap.
   Page-only scripts go in Scripts/<pagename>.js.
   ===================================================================== */
(function () {
    "use strict";

    /* 1. File inputs: check type and size before upload.
          Usage: <asp:FileUpload ... data-max-mb="2" accept=".jpg,.jpeg,.png" />
          The server repeats the same checks; this only saves a wasted upload. */
    function checkFile(input) {
        var maxMb = parseFloat(input.getAttribute("data-max-mb") || "0");
        var accept = (input.getAttribute("accept") || "").toLowerCase();
        var msg = "";

        if (input.files && input.files.length > 0) {
            var file = input.files[0];
            var name = file.name.toLowerCase();
            var ext = name.substring(name.lastIndexOf("."));

            if (accept && accept.split(",").indexOf(ext) === -1) {
                msg = "Choose a " + accept.replace(/\./g, "").toUpperCase().replace(/,/g, " or ") + " file.";
            } else if (maxMb > 0 && file.size > maxMb * 1024 * 1024) {
                msg = "The file is " + (file.size / 1024 / 1024).toFixed(1) + " MB. The limit is " + maxMb + " MB.";
            }
        }

        var holder = document.getElementById(input.id + "_clientError");
        if (!holder) {
            holder = document.createElement("span");
            holder.id = input.id + "_clientError";
            holder.className = "text-danger d-block";
            holder.setAttribute("role", "alert");
            input.parentNode.insertBefore(holder, input.nextSibling);
        }
        holder.textContent = msg;
        input.classList.toggle("is-invalid-file", msg !== "");
        if (msg) {
            input.value = "";
        }
    }

    /* 2. Character counters for text boxes with a limit.
          Usage: <asp:TextBox ... data-counter="500" /> */
    function attachCounter(box) {
        var limit = parseInt(box.getAttribute("data-counter"), 10);
        var counter = document.createElement("div");
        counter.className = "form-text text-end";
        counter.setAttribute("aria-live", "polite");
        box.parentNode.insertBefore(counter, box.nextSibling);

        function update() {
            var used = box.value.length;
            counter.textContent = used + " / " + limit + " characters";
            counter.classList.toggle("text-danger", used > limit);
        }
        box.addEventListener("input", update);
        update();
    }

    /* 3. Fade out success messages after a few seconds (errors stay). */
    function fadeSuccess(el) {
        window.setTimeout(function () {
            el.style.transition = "opacity 0.6s";
            el.style.opacity = "0";
            window.setTimeout(function () { el.style.display = "none"; }, 650);
        }, 6000);
    }

    document.addEventListener("DOMContentLoaded", function () {
        Array.prototype.forEach.call(
            document.querySelectorAll("input[type=file][data-max-mb]"),
            function (input) {
                input.addEventListener("change", function () { checkFile(input); });
            });

        Array.prototype.forEach.call(
            document.querySelectorAll("[data-counter]"),
            attachCounter);

        Array.prototype.forEach.call(
            document.querySelectorAll(".alert-success[data-autohide]"),
            fadeSuccess);
    });
})();
