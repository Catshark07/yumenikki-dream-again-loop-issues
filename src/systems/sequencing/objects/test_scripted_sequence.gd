extends Interactable

func _interact() -> void:
	var seq: SequencerManager.SequenceObject = SequencerManager.create_sequence()
		
	seq.append(EVO_PlayBGM.new())
	seq.append(EVO_PlaySound.new(load("res://src/audio/se/voice_mado_no-1.WAV")))
