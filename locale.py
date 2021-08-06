with open('/etc/locale.gen', 'r') as file:
	data = file.readlines()
data[177] = "en_US.UTF-8 UTF-8\n"

with open('/etc/locale.gen', 'w') as file:
	file.writelines(data)
