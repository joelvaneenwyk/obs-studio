#pragma once
#include <cinttypes>
#include <functional>
#include <map>
#include <string>

extern "C" {
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <curl/curl.h>
}

namespace util {
	typedef std::function<size_t(void*, size_t, size_t)>                   curl_io_callback_t;
	typedef std::function<int32_t(uint64_t, uint64_t, uint64_t, uint64_t)> curl_xferinfo_callback_t;
	typedef std::function<void(CURL*, curl_infotype, char*, size_t)>       curl_debug_callback_t;

	class curl {
		CURL*                              _curl;
		curl_io_callback_t                 _read_callback;
		curl_io_callback_t                 _write_callback;
		curl_xferinfo_callback_t           _xferinfo_callback;
		curl_debug_callback_t              _debug_callback;
		std::map<std::string, std::string> _headers;

		static int32_t debug_helper(CURL* handle, curl_infotype type, char* data, size_t size, util::curl* userptr);
		static size_t  read_helper(void*, size_t, size_t, util::curl*);
		static size_t  write_helper(void*, size_t, size_t, util::curl*);
		static int32_t xferinfo_callback(util::curl*, curl_off_t, curl_off_t, curl_off_t, curl_off_t);

		public:
		curl();
		~curl();

		template<typename _Ty1>
		CURLcode set_option(CURLoption opt, _Ty1 value)
		{
			return curl_easy_setopt(_curl, opt, value);
		};

		template<>
		CURLcode set_option(CURLoption opt, const bool value)
		{
			// CURL does not seem to accept boolean, so we err on the side of safety here.
			return curl_easy_setopt(_curl, opt, value ? 1 : 0);
		};

		template<>
		CURLcode set_option(CURLoption opt, const std::string value)
		{
			return curl_easy_setopt(_curl, opt, value.c_str());
		};

		template<>
		CURLcode set_option(CURLoption opt, const std::string_view value)
		{
			return curl_easy_setopt(_curl, opt, value.data());
		};

		template<typename _Ty1>
		CURLcode get_info(CURLINFO info, _Ty1& value)
		{
			return curl_easy_getinfo(_curl, info, &value);
		};

		template<>
		CURLcode get_info(CURLINFO info, std::vector<char>& value)
		{
			char* buffer;
			if (CURLcode res = curl_easy_getinfo(_curl, info, &buffer); res != CURLE_OK) {
				return res;
			}
			value.resize(strlen(buffer) + 1);
			memcpy(value.data(), buffer, value.size());
			return CURLE_OK;
		};

		template<>
		CURLcode get_info(CURLINFO info, std::string& value)
		{
			std::vector<char> buffer;
			if (CURLcode res = get_info(info, buffer); res != CURLE_OK) {
				return res;
			}
			value = std::string(buffer.data(), buffer.data() + strlen(buffer.data()));
			return CURLE_OK;
		};

		void clear_headers();

		void clear_header(std::string header);

		void set_header(std::string header, std::string value);

		CURLcode perform();

		void reset();

		public /* Helpers */:
		CURLcode set_read_callback(curl_io_callback_t cb);

		CURLcode set_write_callback(curl_io_callback_t cb);

		CURLcode set_xferinfo_callback(curl_xferinfo_callback_t cb);

		CURLcode set_debug_callback(curl_debug_callback_t cb);
	};
} // namespace util
