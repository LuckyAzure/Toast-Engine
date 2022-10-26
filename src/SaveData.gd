class_name SaveData 

const save_file = "user://luckyfunkin.sav"
var save_data = {}

func save_data():
	var file = File.new()
	file.open(save_file,File.WRITE)
	file.store_var(save_data)
	file.close()

func load_data():
	var file = File.new()
	if !file.file_exists(save_file):
		save_data = {
			
		}
		save_data()
	file.open(save_file,File.READ)
	save_data = file.get_var()
	file.close()
