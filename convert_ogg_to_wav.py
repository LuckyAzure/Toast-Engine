import os
from pydub import AudioSegment

def convert_ogg_to_wav(ogg_path, wav_path):
    ogg_audio = AudioSegment.from_ogg(ogg_path)
    wav_audio = ogg_audio.set_frame_rate(44100)  # Set the desired frame rate
    wav_audio.export(wav_path, format="wav")

def convert_folder_files(folder_path):
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.lower().endswith(".ogg"):
                ogg_path = os.path.join(root, file)
                wav_filename = file[:-4] + ".wav"
                wav_path = os.path.join(root, wav_filename)
                convert_ogg_to_wav(ogg_path, wav_path)
                print(f"Converted {file} to {wav_filename}")

if __name__ == "__main__":
    source_folder = "assets/songs"
    convert_folder_files(source_folder)
    
    input("Conversion completed. Press Enter to exit.")
