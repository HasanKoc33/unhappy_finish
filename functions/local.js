const express = require("express");
const app = express();

// JSON formatında veri alabilmek için
app.use(express.json());


const axios = require("axios");

// GET isteği örneği
app.post("/start", async (req, res) => {
    const deviceId = req.body.deviceId;
    const data = await deviceSearch(deviceId);
    if (data) {
        const result = await seansStart(data);
        res.status(200).send(result);
    } else {
        res.status(400).send(false);
    }
});

app.post("/write", async (req, res) => {
    const deviceId = req.body.deviceId;
    const data = await deviceSearch(deviceId);
    if (data) {
        data.data = req.body.data;
        const result = await seansWrite(data);
        res.status(200).send(result);
    } else {
        res.status(400).send(false);
    }
});

app.post("/end", async (req, res) => {
    const deviceId = req.body.deviceId;
    const data = await deviceSearch(deviceId);
    if (data) {
        data.data = req.body.data;
        const w = await seansWrite(data);
        const result = await seansEnd(data);
        res.status(200).send(result);
    } else {
        res.status(400).send(false);
    }
});

async function deviceSearch(deviceId) {
    const solData = await axios.get('https://unhappy-ending-default-rtdb.firebaseio.com/personeller.json?orderBy="sol_bileklik_id"&equalTo="' + deviceId + '"&print=pretty');
    const sagData = await axios.get('https://unhappy-ending-default-rtdb.firebaseio.com/personeller.json?orderBy="sag_bileklik_id"&equalTo="' + deviceId + '"&print=pretty');

    if (Object.keys(solData.data).length > 0 && solData.data.constructor === Object) {
        return {
            kol: "solBileklik",
            id: Object.values(solData.data)[0].id
        };
    } else if (Object.keys(sagData.data).length > 0 && sagData.data.constructor === Object) {
        return {
            kol: "sagBileklik",
            id: Object.values(sagData.data)[0].id
        };
    } else {
        return false;
    }

}

async function seansStart(data) {
    const startData = await axios.put('https://unhappy-ending-default-rtdb.firebaseio.com/personeller/' + data.id + '/' + data.kol + '/continuing.json',

        {
          "startTime": new Date().toISOString()
        }
    );

    if (Object.keys(startData.data).length > 0 && startData.data.constructor === Object) {
        return true;
    } else {
        return false;
    }

}

async function seansWrite(data) {
    const list = {};
    data.data.forEach(element => {
        list[new Date().toISOString().replaceAll('.','*')] = element;
    });
    const startData = await axios.patch('https://unhappy-ending-default-rtdb.firebaseio.com/personeller/' + data.id + '/' + data.kol + '/continuing/data.json',
        list
    );

    if (Object.keys(startData.data).length > 0 && startData.data.constructor === Object) {
        return true;
    } else {
        return false;
    }

}

async function seansEnd(data) {
    const continuing = await axios.get('https://unhappy-ending-default-rtdb.firebaseio.com/personeller/' + data.id + '/' + data.kol + '/continuing.json',);
    continuing.data.endTime = new Date().toISOString();
    const key = new Date().toISOString().split('.')[0];
    const endData = await axios.patch('https://unhappy-ending-default-rtdb.firebaseio.com/personeller/' + data.id + '/' + data.kol + '/seanslar/'+key+'.json',
        continuing.data
    );

    if (Object.keys(endData.data).length > 0 && endData.data.constructor === Object) {
        const del = await axios.delete('https://unhappy-ending-default-rtdb.firebaseio.com/personeller/' + data.id + '/' + data.kol + '/continuing.json',);
        return true;
    } else {
        return false;
    }

}





app.listen(3000, () => {
    console.log("Server is running on port 3000");
});
