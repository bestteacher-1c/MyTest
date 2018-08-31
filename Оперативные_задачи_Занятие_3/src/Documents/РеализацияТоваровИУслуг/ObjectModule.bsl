Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	ДополнительныеСвойства.Вставить("ЗаписатьПустойНабор", Ложь);

	Если (ЭтоНовый() = Ложь) Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
			|	РеализацияТоваровИУслуг.Дата
			|ИЗ
			|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
			|ГДЕ
			|	РеализацияТоваровИУслуг.Ссылка = &Ссылка";

		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			ДополнительныеСвойства.Вставить("ДатаДоПерезаписи", ВыборкаДетальныеЗаписи.Дата);

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если (ДополнительныеСвойства.Свойство("ДатаДоПерезаписи") = Истина) Тогда

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
			|	РеализацияТоваровИУслуг.Дата
			|ИЗ
			|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
			|ГДЕ
			|	РеализацияТоваровИУслуг.Ссылка = &Ссылка";

		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

			Если ВыборкаДетальныеЗаписи.Дата > ДополнительныеСвойства.ДатаДоПерезаписи Тогда

				ДополнительныеСвойства.Вставить("ЗаписатьПустойНабор", Истина);

			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	
	#Область БлокировкаДанных
		Блокировка = Новый БлокировкаДанных;
		
		ЧтоБлокируем = Блокировка.Добавить("РегистрНакопления.ОстаткиТоваров");
		ЧтоБлокируем.УстановитьЗначение("Склад", Склад);
		ЧтоБлокируем.ИсточникДанных = Товары;
		ЧтоБлокируем.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	
		
		ЧтоБлокируем = Блокировка.Добавить("РегистрНакопления.СебестоимостьТоваров");
		ЧтоБлокируем.ИсточникДанных = Товары;
		ЧтоБлокируем.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
		
		Блокировка.Заблокировать();
	#КонецОбласти
	
	
	
	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.СебестоимостьТоваров.Записывать = Истина;
	Движения.Записать();

	#Область Запрос

		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	РеализацияТовары.Номенклатура КАК Номенклатура,
		|	СУММА(РеализацияТовары.Количество) КАК Количество
		|ПОМЕСТИТЬ ВТТоварыДокумента
		|ИЗ
		|	Документ.РеализацияТоваровИУслуг.Товары КАК РеализацияТовары
		|ГДЕ
		|	РеализацияТовары.Ссылка = &Ссылка
		|	И РеализацияТовары.Номенклатура.Услуга = ЛОЖЬ
		|СГРУППИРОВАТЬ ПО
		|	РеализацияТовары.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОстаткиТоваровОстатки.Номенклатура КАК Номенклатура,
		|	ОстаткиТоваровОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ПОМЕСТИТЬ ВТОстаткиТоваров
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&Период, Склад = &Склад
		|	И Номенклатура В
		|		(ВЫБРАТЬ
		|			ВТТоварыДокумента.Номенклатура
		|		ИЗ
		|			ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК ОстаткиТоваровОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СебестоимостьТоваровОстатки.Номенклатура,
		|	СебестоимостьТоваровОстатки.КоличествоОстаток,
		|	СебестоимостьТоваровОстатки.СебестоимостьОстаток
		|ПОМЕСТИТЬ ВТСебестоимостьТоваров
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров.Остатки(&Период, Номенклатура В
		|		(ВЫБРАТЬ
		|			ВТТоварыДокумента.Номенклатура
		|		ИЗ
		|			ВТТоварыДокумента КАК ВТТоварыДокумента)) КАК СебестоимостьТоваровОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТТоварыДокумента.Номенклатура КАК Номенклатура,
		|	ВТТоварыДокумента.Количество КАК Количество,
		|	ЕСТЬNULL(ВТОстаткиТоваров.КоличествоОстаток, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(ВТСебестоимостьТоваров.СебестоимостьОстаток, 0) КАК СебестоимостьОстатокСебестоимость,
		|	ЕСТЬNULL(ВТСебестоимостьТоваров.КоличествоОстаток, 0) КАК КоличествоОстатокСебестоимость
		|ИЗ
		|	ВТТоварыДокумента КАК ВТТоварыДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТОстаткиТоваров КАК ВТОстаткиТоваров
		|		ПО ВТТоварыДокумента.Номенклатура = ВТОстаткиТоваров.Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСебестоимостьТоваров КАК ВТСебестоимостьТоваров
		|		ПО ВТТоварыДокумента.Номенклатура = ВТСебестоимостьТоваров.Номенклатура";

		Запрос.УстановитьПараметр("Период", МоментВремени());
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Склад", Склад);

	#КонецОбласти

	#Область ОбработкаРезультатаЗапроса

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл

			Нехватка = Выборка.Количество - Выборка.КоличествоОстаток;

			Если Нехватка > 0 Тогда

				Отказ = Истина;

				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Не хватает " + Выборка.Номенклатура + ". Нехватка "
					+ Нехватка;
				Сообщение.Сообщить();

			КонецЕсли;

			Если (Отказ = Ложь) Тогда

				//Заполняем набор записей по регистру ОстаткиТоваров
				Движение = Движения.ОстаткиТоваров.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.Номенклатура = Выборка.Номенклатура;
				Движение.Склад = Склад;
				Движение.Количество = Выборка.Количество;

				//Заполняем набор записей по регистру СебестоимостьТоваров	
				Движение = Движения.СебестоимостьТоваров.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.Номенклатура = Выборка.Номенклатура;
				Движение.Количество = Выборка.Количество;

				Если Выборка.КоличествоОстатокСебестоимость = 0 Тогда
					Себестоимость = 0;
				ИначеЕсли Выборка.КоличествоОстатокСебестоимость = Выборка.Количество Тогда
					Себестоимость = Выборка.СебестоимостьОстатокСебестоимость;
				Иначе
					Себестоимость = Выборка.Количество
						* (Выборка.СебестоимостьОстатокСебестоимость
						/ Выборка.КоличествоОстатокСебестоимость);
				КонецЕсли;

				Движение.Себестоимость = Себестоимость;

				
				//Заполняем набор записей по регистру Продажи
				Движение = Движения.Продажи.Добавить();
				Движение.Период = Дата;
				Движение.Номенклатура = Выборка.Номенклатура;
				Движение.Контрагент = Контрагент;
				Движение.Склад = Склад;
				Движение.Менеджер = Менеджер;
				Движение.Количество = 0;
				Движение.Сумма = 0;
				Движение.Себестоимость = Себестоимость;

			КонецЕсли;

		КонецЦикла;

	#КонецОбласти

	Если (Отказ = Истина) Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ТекСтрокаТовары Из Товары Цикл

		Движение = Движения.Продажи.Добавить();
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Контрагент = Контрагент;
		Движение.Склад = Склад;
		Движение.Менеджер = Менеджер;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Себестоимость = 0;

	КонецЦикла;

	Движение = Движения.Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Сумма = Товары.Итог("Сумма");

	Движения.Взаиморасчеты.Записывать = Истина;
	Движения.ОстаткиТоваров.Записывать = Истина;
	Движения.СебестоимостьТоваров.Записывать = Истина;
	Движения.Продажи.Записывать = Истина;

КонецПроцедуры

Процедура ЗарезервироватьТовары() Экспорт
КонецПроцедуры
