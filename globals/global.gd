extends Node

static func enable_bit(mask: int, index: int) -> int:
    return mask | (1 << (index - 1))

static func disable_bit(mask: int, index: int) -> int:
    return mask & ~(1 << (index - 1))


static func set_canvas_item_light_mask_value(canvas_item: CanvasItem, layer_number: int, value: bool) -> void:
    assert(layer_number >= 1 and layer_number <= 20, "layer_number must be between 1 and 20 inclusive")
    if value:
        canvas_item.light_mask = enable_bit(canvas_item.light_mask, layer_number)
    else:
        canvas_item.light_mask = disable_bit(canvas_item.light_mask, layer_number)


static func get_canvas_item_light_mask_value(canvas_item: CanvasItem, layer_number: int) -> bool:
    assert(layer_number >= 1 and layer_number <= 20, "layer_number must be between 1 and 20 inclusive")
    return bool(canvas_item.light_mask & (1 << (layer_number - 1)))
