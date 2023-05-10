cat <<EOF >> generate_new_commands_single_rack.py
#!/usr/bin/python
import sys, getopt
from aos.sdk.client import Client, ClientError
from aos.sdk.graph import query as q
import random

def createData(slicer_aos_ip):
   counter_names = ['txUnicastPackets', 'rxUnicastPackets']
   int_names = ['Ethernet{}'.format(i) for i in range(1,5)]
   int_names.append('Ethernet49/1')
   int_names.append('Ethernet50/1')
   max_counter = 1e10
   counter_values = []
   for val in [0,10,30,50,70,90]:
       counter_values.append(int(max_counter*val/100))

   # debugging
   #slicer_aos_ip = '173.20.158.3'

   print '---->AOS Slicer IP is', slicer_aos_ip
   client = Client(url='https://%s/api' % slicer_aos_ip, verify_certificates=False)
   client.login(username='admin', password='$1')
   blueprint_id = client.blueprints.list()[0]['id']
   blueprint = client.blueprints[blueprint_id].get()


   systems = [sys.system_id for sys in blueprint.get_nodes("system", system_id=q.not_none(), role='leaf')]
   # print systems
   #systems = ["0EA592760005"]

   with open('sim_traffic.txt', 'w') as fp:
       for sys in systems:
           text = "simulate traffic {} {} {} constant {}\n"
           for i in int_names:
               counter_value = random.choice(counter_values)
               for counter_name in counter_names:
                   if '/' in i:
                       counter_value = counter_value*10
                   #print text.format(i, counter_name, counter_value)
                   fp.write(text.format(sys, i, counter_name, counter_value))
   print 'File Generated Successfully'
    
def main(argv):
   ip = ''
   try:
      opts, args = getopt.getopt(argv,"hi:",["ip="])
   except getopt.GetoptError:
      print 'USAGE: generate_new_commands_single_rack.py -i <aos_server_ip>'
      sys.exit(2)
   if len(sys.argv) != 3:
       print 'USAGE: generate_new_commands_single_rack.py -i <aos_server_ip>'
       sys.exit()
   for opt, arg in opts:
      if opt == '-h' or opt != '-i':
         print 'USAGE: generate_new_commands_single_rack.py -i <aos_server_ip>'
         sys.exit()
      elif opt in ("-i", "-j"):
         ip = arg
         print 'AOS Slicer IP is', ip

## debugging
#   print 'AOS Slicer IP is', ip
#   print 'Number of arguments:', len(sys.argv), 'arguments.'
#   print 'Argument List:', str(sys.argv)

   createData(ip)


if __name__ == "__main__":
   main(sys.argv[1:])
   
   
   EOF
