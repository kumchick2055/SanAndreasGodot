class_name RwBinMeshPLG
extends RwChunk


var flags: int
var numMeshes: int
var totalNumIndices: int
var meshesList: Array

class MeshData:
	var num_indices: int
	var material_indx: int
	var indices: Array


func _init(file: File).(file) -> void:
	RwStruct.new(file)
	
	flags = file.get_32()
	numMeshes = file.get_32()
	totalNumIndices = file.get_32()
	
	for i in numMeshes:
		var numIndices := file.get_32()
		var matIndx := file.get_32()
		var indices := []
		
		for j in numIndices:
			var vertex = file.get_32()
			indices.append(vertex)
		
		var meshData = MeshData.new()
		meshData.num_indices = numIndices
		meshData.material_indx = matIndx
		meshData.indices = indices
		
#		print(matIndx,'-',numIndices,'-',indices)
		
		meshesList.append(meshData)

