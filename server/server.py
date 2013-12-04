from _thread import start_new_thread
import socket,sys
from threading import *

HOST = '' #all available interfaces
PORT = 8889

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print('socket created')

s.bind((HOST,PORT))
print('socket bound')

s.listen(2)
print('listening')

clients = []

# client connection
def client_thread(conn):
    #serve client id
    conn.send(("player:"+str(clients.index(conn))).encode())

    #game on if we have two players
    if len(clients)==2:
        conn.send(("play!").encode())

    #receive data
    while True:
        data = conn.recv(1024)

        if not data:
            break

        #debug purposes only
        encodedData = (data.decode('UTF-8'))
        print(encodedData)

        #broadcast message to all clients
        for c in clients:
            c.sendall(data)
    #clean up
    conn.close()
    clients.remove(conn)

# accept loop
while 1:
    conn,addr = s.accept()
    print('connected with ' + addr[0] + ":" + str(addr[1]))
    clients.append(conn)
    start_new_thread(client_thread,(conn,))

s.close()