// AUTOGENERATED COPYRIGHT HEADER START
// Copyright (C) 2020-2023 Michael Fabian 'Xaymar' Dirks <info@xaymar.com>
// AUTOGENERATED COPYRIGHT HEADER END

#pragma once
#include "encoders/encoder-ffmpeg.hpp"
#include "encoders/ffmpeg/handler.hpp"

#include "warning-disable.hpp"
extern "C" {
#include <libavcodec/avcodec.h>
}
#include "warning-enable.hpp"

namespace streamfx::encoder::ffmpeg {
	class prores_aw : public handler {
		public:
		prores_aw();
		virtual ~prores_aw();

		virtual bool has_keyframes(ffmpeg_factory* factory);

		virtual std::string help(ffmpeg_factory* factory) {
			return "https://github.com/Xaymar/obs-StreamFX/wiki/Encoder-FFmpeg-Apple-ProRes";
		}

		virtual void defaults(ffmpeg_factory* factory, obs_data_t* settings);
		virtual void properties(ffmpeg_factory* factory, ffmpeg_instance* instance, obs_properties_t* props);
		virtual void update(ffmpeg_factory* factory, ffmpeg_instance* instance, obs_data_t* settings);
		virtual void log(ffmpeg_factory* factory, ffmpeg_instance* instance, obs_data_t* settings);

		virtual void override_colorformat(ffmpeg_factory* factory, ffmpeg_instance* instance, obs_data_t* settings, AVPixelFormat& target_format);
	};
} // namespace streamfx::encoder::ffmpeg
