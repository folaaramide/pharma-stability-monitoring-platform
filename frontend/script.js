const API_URL =
"https://lifvk7dmxg.execute-api.eu-west-2.amazonaws.com/submit";

document.querySelector("button").addEventListener("click", submitResult);

async function submitResult() {

    const batch_id = document.getElementById("batch_id").value;

    const timepoint = document.getElementById("timepoint").value;

    const condition = document.getElementById("condition").value;

    const assay = document.getElementById("assay").value;

    const ph = document.getElementById("ph").value;

    const zinc = document.querySelector(
    'input[name="zinc"]:checked'
    ).value;

    const response = await fetch(API_URL, {

    method: "POST",

    headers: {

        "Content-Type": "application/json"

    },

    body: JSON.stringify({

        batch_id,

        timepoint,

        condition,

        assay,

        zinc,

        ph

    })

});

const data = await response.json();

document.getElementById("result").innerHTML =

`${data.message} - ${data.status}`;

}