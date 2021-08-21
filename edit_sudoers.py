with open('/etc/sudoers', 'r') as file:
	data = file.readlines()
data[82] = "%wheel ALL=(ALL) ALL\n"

with open('/etc/sudoers', 'w') as file:
	file.writelines(data)
