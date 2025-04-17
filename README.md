# 💀 BONES DEV - Discord Nickname Validator for FiveM

This resource prevents players from joining your FiveM server unless their in-game name matches their Discord nickname (or username if no nickname is set).

Built using:
- 🟢 Node.js for Discord API validation
- 🔵 Lua for server-side enforcement
- 💀 BONES DEV-style branding (of course)

---

## 📦 Features

- Validates player names against Discord nicknames in real-time
- Kicks players with mismatched names and explains why
- Sends startup webhooks to Discord
- Custom BONES DEV ASCII branding in console
- Detailed debug logging built-in

---

## 🔧 Installation Instructions

### 1. Clone or Download This Repository

Put the Lua resource folder (e.g. `bonesusername`) in your server’s `resources` folder:

```
resources/
└── bonesusername/
        ├── fxmanifest.lua
        ├── server.lua
```

### 2. Set Up the Node.js API Server

Create a folder **outside of your resources** called something like `nickname-api`. Put the following files inside:

- `check-nickname.js`
- `package.json` (optional, you can use `npm init -y`)
- Run `npm install express axios`

Start it with:

```bash
node check-nickname.js
```

You should see:
```
Nickname validator API running on port 4000
Webhook sent successfully
```

> ✅ Optional: Use [PM2](https://pm2.keymetrics.io/) to auto-start on boot.

---

### 3. Update the FiveM Lua Script

In `server.lua`, make sure this line points to the correct IP of your API server:

```lua
local CHECK_API_URL = "http://YOUR-SERVER-IP:4000/check-nickname"
```

If you're running both on the same machine, you can use:

```lua
"http://127.0.0.1:4000/check-nickname"
```

Make sure your Node.js API is listening on `0.0.0.0`:

```js
app.listen(4000, '0.0.0.0', () => {
  console.log('API running');
});
```

---

### 4. Start the Resource

In your `server.cfg`:

```cfg
ensure bonesusername
```

When the resource starts, it’ll print the BONES DEV skull in the console and begin checking every player who connects.

---

## ✅ Requirements

- Node.js v16+ (Install from [nodejs.org](https://nodejs.org))
- A Discord bot with:
  - `GUILD_MEMBERS` intent enabled
  - Bot token
  - Access to the guild (server)
---
## Support Server 🖥️
  - https://discord.gg/hBXsshCtjC
---

## 🧠 Bonus Tips

- Add role-based exemptions for staff (we can help you extend it)
- Log mismatches or failed attempts to a webhook
- Use `fs.appendFileSync` in Node to create join logs
- Add Discord embeds to make it look beautiful in your logs
- A current Discord bot can be used as this doesn't directly run the bot. I reccomend to not use a moderation bot, but rather something that your server uses for permissions.
---

## ☠️ Console Preview

```
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
```

---

## 🧑‍💻 Credits

Created with 💀 by BONES DEV.  
Need custom validation systems, APIs, or server scripts? Hit us up.
