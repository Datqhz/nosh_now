const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { JWT } = require('google-auth-library');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.get('/token', async (req, res) =>
{
    try
    {
        const accessToken = await getAccessToken();
        res.json({ accessToken });
    } catch (err)
    {
        res.status(500).send('Failed to get access token ' + err);
    }
});

// Start the server
app.listen(port, () =>
{
    console.log(`Server is running on http://localhost:${port}`);
});

async function getAccessToken()
{
    return new Promise(function(resolve, reject) {
        const key = require('./nosh-62d66-75510f9ca427.json');
        const jwtClient = new JWT(
          key.client_email,
          null,
          key.private_key,
          ['https://www.googleapis.com/auth/firebase.messaging'],
          null
        );
        jwtClient.authorize(function(err, tokens) {
          if (err) {
            reject(err);
            return;
          }
          resolve(tokens.access_token);
        });
      });
}