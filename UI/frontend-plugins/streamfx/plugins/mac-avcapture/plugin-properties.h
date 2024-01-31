//
//  plugin-properties.h
//  obs-studio
//
//  Created by Patrick Heyer on 2023-03-07.
//

@import Foundation;

#import <obs-properties.h>

/// Configures single source property's visibility, possible modification callback and callback payload data, as well as whether the property should be enabled
/// - Parameters:
///   - property: The source property to change
///   - enable: Whether the source property should be enabled (user-changeable)
///   - visible: Whether the source property should be visible
///   - callback: Pointer to a function that will be called if this property has been modified or the properties are reloaded
///   - callback_data: Optional payload data for the callback function
void configure_property(obs_property_t *property, bool enable, bool visible, void *callback, void *callback_data);

/// Generic callback handler for changed properties. Will update all properties of an OBSAVCapture source at once
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source (``OBSAVcaptureInfo``)
///   - properties: Pointer to properties struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_changed(OBSAVCaptureInfo *captureInfo, obs_properties_t *properties, obs_property_t *property,
                        obs_data_t *settings);

/// Callback handler for preset changes.
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source
///   - properties: Pointer to properties struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_changed_preset(OBSAVCaptureInfo *captureInfo, obs_properties_t *properties, obs_property_t *property,
                               obs_data_t *settings);

/// Callback handler for changing preset usage for an OBSAVCapture source. Switches between preset-based configuration and manual configuration
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source
///   - properties: Pointer to properties struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_changed_use_preset(OBSAVCaptureInfo *captureInfo, obs_properties_t *properties,
                                   obs_property_t *property, obs_data_t *settings);

/// Updates preset property with description-value-pairs of presets supported by the currently selected device
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_update_preset(OBSAVCaptureInfo *captureInfo, obs_property_t *property, obs_data_t *settings);

/// Updates device property with description-value-pairs of devices available via CoreMediaIO
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_update_device(OBSAVCaptureInfo *captureInfo, obs_property_t *property, obs_data_t *settings);

/// Updates available values for all properties required in manual device configuration.
///
/// Properties updated by this call include:
/// * Resolutions
/// * Frame rates and frame rate ranges
/// * Color formats
/// * Color range
///
///  In CoreMediaIO color format, resolution and frame rate ranges are always coupled into a single format, while color range is always contained in the color format. The formats are thus compiled and de-duplicated to create a selection of all properties.
///
///  Frame rate ranges will be limited to ranges only available for a specific combination of resolution and color format.
///
/// - Parameters:
///   - captureInfo: Pointer to capture info struct associated with the source
///   - property: Pointer to the property that the callback is attached to
///   - settings: Pointer to settings associated with the source
/// - Returns: Always returns true
bool properties_update_config(OBSAVCaptureInfo *captureInfo, obs_properties_t *properties, obs_data_t *settings);
