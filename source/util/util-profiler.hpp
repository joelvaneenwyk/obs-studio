// AUTOGENERATED COPYRIGHT HEADER START
// Copyright (C) 2020-2023 Michael Fabian 'Xaymar' Dirks <info@xaymar.com>
// AUTOGENERATED COPYRIGHT HEADER END

#pragma once
#include "common.hpp"

#include "warning-disable.hpp"
#include <chrono>
#include <map>
#include <mutex>
#include "warning-enable.hpp"

namespace streamfx::util {
	class profiler : public std::enable_shared_from_this<streamfx::util::profiler> {
		std::map<std::chrono::nanoseconds, size_t> _timings;
		std::mutex                                 _timings_lock;

		public:
		class instance {
			std::shared_ptr<profiler>                      _parent;
			std::chrono::high_resolution_clock::time_point _start;

			public:
			instance(std::shared_ptr<profiler> parent);

			~instance();

			void cancel();

			void reparent(std::shared_ptr<profiler> parent);
		};

		private:
		profiler();

		public:
		~profiler();

		std::shared_ptr<class streamfx::util::profiler::instance> track();

		void track(std::chrono::nanoseconds duration);

		uint64_t count();

		std::chrono::nanoseconds total_duration();

		double_t average_duration();

		std::chrono::nanoseconds percentile(double_t percentile, bool by_time = false);

		public:
		static std::shared_ptr<streamfx::util::profiler> create()
		{
			return std::shared_ptr<streamfx::util::profiler>{new profiler()};
		}
	};
} // namespace streamfx::util
