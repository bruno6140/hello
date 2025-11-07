// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/hello_web/endpoint.ex". We pass the
// token for authentication.
//
// Read the [`Using Token Authentication`](https://hexdocs.pm/phoenix/channels.html#using-token-authentication)
// section to see how the token should be used.
let socket = new Socket("/socket")
socket.connect()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
document.addEventListener("DOMContentLoaded", () => {
  const chatInput = document.getElementById("chat-input")
  if (!chatInput) return

  const username = localStorage.getItem("username")
  const lobby = localStorage.getItem("lobby") || "lobby"
  
  // Actualizar UI con información del usuario
  const myUidElement = document.getElementById("myUid")
  const currentLobbyElement = document.getElementById("currentLobby")
  if (myUidElement) myUidElement.innerText = username
  if (currentLobbyElement) currentLobbyElement.innerText = lobby

  // Unirse al canal con el lobby específico
  const channel = socket.channel(`room:${lobby}`, { user_id: username })
  const messagesContainer = document.getElementById("messages")

  chatInput.addEventListener("keypress", event => {
    if(event.key === 'Enter' && chatInput.value.trim() !== ""){
      channel.push("new_msg", { body: chatInput.value, user_id: username })
      chatInput.value = ""
    }
  })

  channel.on("new_msg", payload => {
    let messageItem = document.createElement("p")
    messageItem.innerText = `[${payload.user_id}] ${payload.body}`
    messagesContainer.appendChild(messageItem)
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  })

  channel.join()
    .receive("ok", () => console.log(`Conectado a room:${lobby}`))
    .receive("error", err => console.error("Error al unirse:", err))
})

export { socket }