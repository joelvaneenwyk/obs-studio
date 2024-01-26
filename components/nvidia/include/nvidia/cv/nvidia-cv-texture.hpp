// AUTOGENERATED COPYRIGHT HEADER START
// Copyright (C) 2020-2023 Michael Fabian 'Xaymar' Dirks <info@xaymar.com>
// AUTOGENERATED COPYRIGHT HEADER END

#pragma once
#include "nvidia/cv/nvidia-cv-image.hpp"
#include "obs/gs/gs-texture.hpp"

#include "warning-disable.hpp"
#include <cinttypes>
#include "warning-enable.hpp"

namespace streamfx::nvidia::cv {
	using ::streamfx::nvidia::cv::component_layout;
	using ::streamfx::nvidia::cv::component_type;
	using ::streamfx::nvidia::cv::image;
	using ::streamfx::nvidia::cv::memory_location;
	using ::streamfx::nvidia::cv::pixel_format;

	class texture : public image {
		std::shared_ptr<::streamfx::obs::gs::texture> _texture;

		public:
		~texture() override;
		texture(uint32_t width, uint32_t height, gs_color_format pix_fmt);

		void resize(uint32_t width, uint32_t height) override;

		std::shared_ptr<::streamfx::obs::gs::texture> get_texture();

		private:
		void alloc();
		void free();
	};

} // namespace streamfx::nvidia::cv
