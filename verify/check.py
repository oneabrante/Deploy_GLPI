import subprocess
import sys
import time

def check():
    containersGlpi = [
        {"name": "glpi"},
    ]
    print("========================================= GLPI =========================================")
    for container in containersGlpi:
        print()
        data = time.strftime("%d/%m/%Y %H:%M:%S")
        print(f"Container: {container['name']} - {data}")
        print()
        print("Container Status: ")
        status = subprocess.run(["docker", "inspect", "-f", "{{.State.Status}}", container["name"]], stdout=subprocess.PIPE)
        if status.stdout.decode("utf-8").strip() == "running":
            print("\033[92m+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[92m| Container Running |\033[0m")
            print("\033[92m+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print()
        else:
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[91m| Container Not Running. Check the container logs. |\033[0m")
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print()
            sys.exit(1)
        print("NGINX Status: ")
        command1 = ["docker", "exec", container["name"], "/bin/sh", "-c", "service nginx status"]
        result1 = subprocess.run(command1, capture_output=True, text=True)
        print()
        if result1.returncode == 0:
            print("\033[92m+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[92m| NGINX Running |\033[0m")
            print("\033[92m+-+-+-+-+-+-+-+-+\033[0m")
            print()
            command2 = ["docker", "exec", container["name"], "/bin/sh", "-c", "curl -I http://localhost"]
            result2 = subprocess.run(command2, capture_output=True, text=True)
            print(result2.stdout)
        else:
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[91m| NGINX with error. Check the logs. |\033[0m")
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print()
            sys.exit(1)
        print("PHP-FPM Status: ")
        command3 = ["docker", "exec", container["name"], "/bin/sh", "-c", "service php8.3-fpm status"]
        result3 = subprocess.run(command3, capture_output=True, text=True)
        print() 
        if result3.returncode == 0:
            print("\033[92m+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[92m| PHP-FPMv8.3 Running |\033[0m")
            print("\033[92m+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print()
        else:
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print("\033[91m| PHP-FPM v8.3 is required. Check the logs. |\033[0m")
            print("\033[91m+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+\033[0m")
            print()
            sys.exit(1)
    print("========================================================================================")

check()
        