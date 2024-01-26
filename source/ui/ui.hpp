// AUTOGENERATED COPYRIGHT HEADER START
// Copyright (C) 2020-2023 Michael Fabian 'Xaymar' Dirks <info@xaymar.com>
// AUTOGENERATED COPYRIGHT HEADER END

#pragma once
#include "ui-common.hpp"
#include "ui-about.hpp"
#include "ui-updater.hpp"

namespace streamfx::ui {
	class handler : public QObject {
		Q_OBJECT

		private:
		QAction* _menu_action;
		QMenu*   _menu;

		// Menu Actions
		QAction* _action_support;
		QAction* _action_wiki;
		QAction* _action_website;
		QAction* _action_discord;
		QAction* _action_twitter;
		QAction* _action_youtube;

		// About Dialog
		QAction*   _about_action;
		ui::about* _about_dialog;

		QTranslator* _translator;

		std::shared_ptr<streamfx::ui::updater> _updater;

		private:
		handler();

		public:
		~handler();

		bool have_shown_about_streamfx(bool shown = false);

		private:
		static void frontend_event_handler(obs_frontend_event event, void* private_data);

		void on_obs_loaded();
		void on_obs_exit();

		public slots:
		; // Not having this breaks some linters.

		// Menu Actions
		void on_action_support(bool);
		void on_action_wiki(bool);
		void on_action_website(bool);
		void on_action_discord(bool);
		void on_action_twitter(bool);
		void on_action_youtube(bool);

		// About
		void on_action_about(bool);

		public /* Singleton */:
		static std::shared_ptr<ui::handler> instance();
	};

	class translator : public QTranslator {
		public:
		translator(QObject* parent = nullptr);
		~translator();

		virtual QString translate(const char* context, const char* sourceText, const char* disambiguation = nullptr, int n = -1) const override;
	};

} // namespace streamfx::ui
