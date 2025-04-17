const express = require('express');
const axios = require('axios');
const fs = require('fs');
const app = express();

## Change these!
const BOT_TOKEN = 'YOUR_BOT_TOKEN';
const GUILD_ID = 'YOUR_GUILD_ID';
const WEBHOOK_URL = 'YOUR_WEBHOOK_URL';

console.clear();
const startupBanner = `
      ______
    .-'      '-.
   /            \
  |              |
  |,  .-.  .-.  ,|
  | )(_o/  \o_)( |
  |/     /\     \|
  (_     ^^     _)
   \__|IIIIII|__/
    | \IIIIII/ |
    \          /
     `--------`

 ██████   ██████  ███    ██ ███████ ██████      
 ██   ██ ██    ██ ████   ██ ██      ██        
 ██████  ██    ██ ██ ██  ██ █████     ███        
 ██   ██ ██    ██ ██  ██ ██ ██           ██     
 ███████  ██████  ██   ████ ███████ ███████   
           ☠️  BONES DEV  ☠️    
`;

console.log(startupBanner);
fs.writeFileSync('startup.log', startupBanner, { flag: 'w' });

app.get('/check-nickname', async (req, res) => {
    const { discordId, playerName } = req.query;

    if (!discordId || !playerName) {
        return res.status(400).json({ error: "Missing parameters" });
    }

    try {
        const response = await axios.get(`https://discord.com/api/v10/guilds/${GUILD_ID}/members/${discordId}`, {
            headers: { Authorization: `Bot ${BOT_TOKEN}` }
        });

        const nickname = response.data.nick || response.data.user.username;
        const isMatch = nickname.toLowerCase() === playerName.toLowerCase();

        console.log(`[CHECK] ${playerName} vs ${nickname} — Match: ${isMatch}`);
        res.json({ match: isMatch, nickname });
    } catch (err) {
        console.error("[ERROR] Discord nickname fetch failed:", err.response?.data || err.message);
        res.status(500).json({ error: "Failed to get nickname from Discord" });
    }
});

app.listen(4000, '0.0.0.0', () => {
    console.log('Nickname validator API running on port 4000');
    axios.post(WEBHOOK_URL, {
        content: "**[API Check]** Nickname validator is up and running!"
    }).then(() => {
        console.log("Webhook sent successfully");
    }).catch((err) => {
        console.error("Webhook failed:", err.response?.data || err.message);
    });
});
