# -*- mode: snippet -*-
# name  : gltf.extract
# uuid  : gltf.extract
# key   : gltf.extract
# group : gltf file
# --
# https://8bit-memories.com/projects/godot-recipes/gltf_extract.gd
# Import script for GLTF files which automates extraction of meshes and colliders.
# Useful if you don't want to rely on the scenes created by the GLTF import process.
#
# Notes:
# * Resources will be saved in the path where the GLTF/GLB file is located.
# * Names of resources are based on name of the individual nodes.
# * Extraction of collision shapes will only work if these meshes have been markes as such.
#   I.e. -col, -colonly, etc. See https://docs.godotengine.org/en/latest/tutorials/assets_pipeline/importing_3d_scenes/node_type_customization.html
# * BEWARE1: This script works great for my workflow, but depending on yours, you might need to make adjustments.
# * BEWARE2: The script will overwrite without asking. So do be careful how you use it.


@tool
extends EditorScenePostImport

var res_prefix: String = ""
var extract_meshes: bool = true # Extract meshes?
var extract_colliders: bool = true # Extract collision shapes?
var use_filename_prefix: bool = true # use file name of gltf as prefix for each resource?


func _post_import(scene: Node):
	if use_filename_prefix:
		res_prefix = str(get_source_file().get_basename(), "-")
	else:
		res_prefix = str(get_source_file().get_base_dir(), "/")
	extract_resources(scene)
	return scene


func extract_resources(parent: Node3D) -> void:
	if parent == null:
		return

	for i: int in parent.get_child_count():
		var child: Node3D = parent.get_child(i) as Node3D

		if extract_meshes && (child is MeshInstance3D):
			var mi: MeshInstance3D = child as MeshInstance3D
			ResourceSaver.save(mi.mesh, str(res_prefix, child.name.to_lower(), ".res"))

		if extract_colliders && (child is CollisionShape3D) && (parent is CollisionObject3D):
			var col: CollisionShape3D = child as CollisionShape3D
			ResourceSaver.save(col.shape, str(res_prefix, parent.name.to_lower(), ".shape"))

		if child.get_child_count() > 0:
			extract_resources(child)
