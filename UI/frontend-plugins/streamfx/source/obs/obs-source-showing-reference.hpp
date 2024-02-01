// AUTOGENERATED COPYRIGHT HEADER START
// Copyright (C) 2017-2023 Michael Fabian 'Xaymar' Dirks <info@xaymar.com>
// AUTOGENERATED COPYRIGHT HEADER END

#pragma once
#include "common.hpp"
#include "obs-source.hpp"
#include "obs-tools.hpp"
#include "obs-weak-source.hpp"

namespace streamfx::obs {
	class source_showing_reference {
		::streamfx::obs::weak_source _target;

		public:
		~source_showing_reference()
		{
			auto v = _target.lock();
			if (v) {
				v.decrement_showing();
			}
		}
		source_showing_reference(::streamfx::obs::source& source) : _target(source)
		{
			source.increment_showing();
		}

		public:
		static FORCE_INLINE std::shared_ptr<source_showing_reference> add_showing_reference(::streamfx::obs::source& source)
		{
			return std::make_shared<source_showing_reference>(source);
		}
	};
} // namespace streamfx::obs
