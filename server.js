import express from "express";
import { createServer } from "http";
import WebSocket, { WebSocketServer } from "ws";

const app = express();
const server = createServer(app);
const port = process.env.PORT || 10000;

// HTTP-проверка
app.get("/", (req, res) => res.send("Render WebSocket bridge running OK"));

// WebSocket сервер на /render
const wss = new WebSocketServer({ server, path: "/render" });

wss.on("connection", (ws, req) => {
  console.log("Client connected:", req.socket.remoteAddress);

  // Подключаемся к твоему Xray на VPS
  const backend = new WebSocket("ws://152.44.38.209:2098/render");

  backend.on("open", () => console.log("Connected to backend"));
  backend.on("close", () => console.log("Backend closed"));
  backend.on("error", (e) => console.log("Backend error:", e.message));

  ws.on("message", (msg) => backend.readyState === WebSocket.OPEN && backend.send(msg));
  backend.on("message", (msg) => ws.readyState === WebSocket.OPEN && ws.send(msg));

  ws.on("close", () => backend.close());
  ws.on("error", (e) => console.log("Client error:", e.message));
});

server.listen(port, () => console.log(`Listening on ${port}`));
