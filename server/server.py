from _thread import start_new_thread
import socket

#all available interfaces
HOST = ''
PORT = 8888

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
        c.sendall(data)

def remove_client(connection, client_id):
    del(clients[int(client_id)])
    send_all((client_id+":-1:-1:-1|").encode())

def debug_output(data):
    encoded_data = (data.decode('UTF-8'))
    print(encoded_data)
    print(len(clients))

# client connection handler
# packet format id:keycode:x:y|
def client_thread(connection):
    # send the client id to the connecting client
    client_id = str(clients.index(connection))
    connection.send((client_id+":-1:-1:-1|").encode())

    #receive data
    while True:
        try:
            data = connection.recv(1024)

            if not data:
                break

            #debug_output(data)

            send_all(data)

        except:
            break

    #clean up
    connection.close()
    remove_client(connection, client_id)

# accept loop
while 1:
    conn, address = s.accept()
    print('connected with ' + address[0] + ":" + str(address[1]))
    clients.append(conn)
    start_new_thread(client_thread, (conn,))

s.close()