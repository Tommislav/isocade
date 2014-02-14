#!/usr/bin/python
from thread import start_new_thread
#from Adafruit_CharLCDPlate import Adafruit_CharLCDPlate as LCDPlate
import socket

#all available interfaces
try:
    lcd = LCDPlate()    
except Exception, e:
    print e
    lcd = None

if (lcd):
    lcd.clear()
    lcd.message("OK!")

HOST = ''
PORT = 8888
main_client_id = 0;

TYPE_CONNECTION_HANDSHAKE = "1";
TYPE_NEW_PLAYER_CONNECTED = "2";
TYPE_PLAYER_DISCONNECTED = "3";

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print('socket created')

s.bind((HOST, PORT))
print('socket bound')

s.listen(2)
print('listening')

clients = []

# removes client and sends a message to all connected clients
def send_all(data):
    for c in clients:
        c[0].sendall(data)

def remove_client(connection, client_id):
    #print clients
    c =  [(i,j) for i,j in clients if i == connection]
    #print c
    client_id = str(c[0][1])
    ind = clients.index(c[0])
    #client = str(clients.index(connection))
    del(clients[ind])
    #print clients
    send_all((str(client_id) + ":" + TYPE_PLAYER_DISCONNECTED + "|").encode())
    data = (str(client_id) + ":" + TYPE_PLAYER_DISCONNECTED + "|").encode()
    #print (data.decode('UTF-8'))
    if (lcd):
        lcd.message("\n" + "Clients: " + str(len(clients)))

def debug_output(data):
    encoded_data = (data.decode('UTF-8'))
    #print(encoded_data)
    #print(len(clients))

# client connection handler
# packet format id:keycode:x:y|
def client_thread(connection):
    # send the client id to the connecting client
    print clients

    c =  [j for i,j in clients if i == connection]
    print c
    client_id = str(c[0])

    #client_id = str(clients.index(connection))
    connection.send((client_id + ":" + TYPE_CONNECTION_HANDSHAKE + "|").encode());
    send_all((client_id + ":" + TYPE_NEW_PLAYER_CONNECTED + "|").encode());
    #connection.send((client_id+":-1:-1:-1|").encode())

    #receive data
    while True:
        try:
            data = connection.recv(1024)

            if not data:
                break

            debug_output(data)

            send_all(data)

        except:
            break

    #clean up
    remove_client(connection, client_id)
    connection.close()
# accept loop
while 1:
    conn, address = s.accept()
    msg = 'connected with ' + address[0] + ":" + str(address[1])
    print(msg)
    clients.append((conn,main_client_id))
    main_client_id = main_client_id +1
    
    print clients
    if (lcd):
        lcd.clear()
        msg = address[0] + "\n" + "Clients: " + str(len(clients))
        lcd.message(msg)

    start_new_thread(client_thread, (conn,))

s.close()
