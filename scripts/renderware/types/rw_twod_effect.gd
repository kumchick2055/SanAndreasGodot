class_name RwTwoDEffect
extends RwChunk

var count_effects: int
var effects: Array[TwoDEffect]


class TwoDEffect:
	var position: Vector3
	var entry_type: int
	var data_size: int
	
	var entity: LightEntity



func _init(file: FileAccess) -> void:
	super(file)
	if chunk_type != TWOD_EFFECT:
		file.seek(_start)
		return
		
	assert(chunk_type == TWOD_EFFECT, 'Failed type of chunk - TWOD_EFFECT')
	
	count_effects = file.get_32()
	
	for i in count_effects:
		var effect = TwoDEffect.new()
		effect.position.x = file.get_float()
		effect.position.y = file.get_float()
		effect.position.z = file.get_float()
		
		
		effect.entry_type = file.get_32()
		effect.data_size = file.get_32()
		
		# Light
		if effect.entry_type == 0:
			var entity :=  LightEntity.new()
			
			var color: Color
			color.r = file.get_8() / 255.0
			color.g = file.get_8() / 255.0
			color.b = file.get_8() / 255.0
			color.a = file.get_8() / 255.0
			entity.color = color
			
			entity.coronaFarClip = file.get_float()
			entity.pointlightRange = file.get_float()
			entity.coronaSize = file.get_float()
			entity.shadowSize = file.get_float()
			
			entity.coronaShowMode = file.get_8()
			entity.coronaEnableReflection = file.get_8()
			entity.coronaFlareType = file.get_8()
			entity.shadowColorMultiplier = file.get_8()
			entity.flags1 = file.get_8()
			
			entity.coronaTexName = file.get_buffer(24).get_string_from_ascii()
			entity.shadowTexName = file.get_buffer(24).get_string_from_ascii()
			entity.shadowZDistance = file.get_8()
			entity.flags2 = file.get_8()
			
			if effect.data_size == 76:
				entity.padding = file.get_buffer(1)
			else:
				var x := file.get_8()
				var y := file.get_8()
				var z := file.get_8()
				entity.lookDirection = Vector3(x,y,z)
				entity.padding = file.get_buffer(2)
			
			effect.entity = entity
		
		effects.append(effect)
	


enum CoronaShowMode {
	DEFAULT = 0,
	RANDOM_FLASHING,
	RANDOM_FLASHIN_ALWAYS_AT_WET_WEATHER,
	LIGHTS_ANIM_SPEED_4X,
	LIGHTS_ANIM_SPEED_2X,
	LIGHTS_ANIM_SPEED_1X,
	TRAFFICLIGHT = 7,
	TRAINCROSSLIGHT,
	ALWAYS_DISABLED,
	AT_RAIN_ONLY,
	ON_5S_OFF_5S,
	ON_6S_OFF_4S,
	ON_6S_OFF_4S_2,
}
enum Flags1 {
	CORONA_CHECK_OBSTACLES = 1,
	FOG_TYPE = 2,
	FOG_TYPE_2 = 4,
	WITHOUT_CORONA = 8,
	CORONA_ONLY_AT_LONG_DISTANCE = 16,
	AT_DAY = 32,
	AT_NIGHT = 64,
	BLINKING1 = 128,
}
enum Flags2 {
	CORONA_ONLY_FROM_BELOW = 1,
	BLINKING2 = 2,
	UDPDATE_HEIGHT_ABOVE_GROUND = 4,
	CHECK_DIRECTION = 8,
	BLINKING3 = 16,
}

class LightEntity:
#	0x00 | RwRGBA color                   
#	0x04 | float  coronaFarClip           
#	0x08 | float  pointlightRange         
#	0x0C | float  coronaSize              
#	0x10 | float  shadowSize              
#	0x14 | BYTE   coronaShowMode          
#	0x15 | BYTE   coronaEnableReflection  
#	0x16 | BYTE   coronaFlareType         
#	0x17 | BYTE   shadowColorMultiplier   
#	0x18 | BYTE   flags1                  
#	0x19 | char   coronaTexName[24]       
#	0x31 | char   shadowTexName[24]       
#	0x49 | BYTE   shadowZDistance         
#	0x4A | BYTE   flags2                  
#	0x4B | BYTE   padding

	var color: Color
	var coronaFarClip: float
	var pointlightRange: float
	var coronaSize: float
	var shadowSize: float
	
	var coronaShowMode: int
	var coronaEnableReflection: int
	var coronaFlareType: int
	var shadowColorMultiplier: int
	var flags1: int
	
	var coronaTexName: String
	var shadowTexName: String
	
	var shadowZDistance: int
	var flags2: int
	var padding: PackedByteArray
	
	var lookDirection: Vector3
