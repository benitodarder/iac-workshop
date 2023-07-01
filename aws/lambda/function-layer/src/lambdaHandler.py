import requests
import sys 

def lambda_handler(event, context):
  print("Hello... Let's check layer presence...")
  print(dir(requests))
  print("That's all folks... Bye...")

if __name__ == '__main__':
  sys.exit(lambda_handler(None, None))
