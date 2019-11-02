Процедура ПроверитьПервыйЗапуск() Экспорт
	
	Если Константы.ПервыйЗапуск.Получить() = Ложь Тогда
		
		Константы.ПервыйЗапуск.Установить(Истина);
		
		ОбработатьДокументы();
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьДокументы()
	
	ТекМесяц = НачалоМесяца(ТекущаяДата());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТоваровИУслуг.Ссылка
		|ИЗ
		|	Документ.ПоступлениеТоваровИУслуг КАК ПоступлениеТоваровИУслуг
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПоступлениеТоваровИУслуг.МоментВремени УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеализацияТоваровИУслуг.Ссылка
		|ИЗ
		|	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
		|
		|УПОРЯДОЧИТЬ ПО
		|	РеализацияТоваровИУслуг.МоментВремени УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПолучениеДенег.Ссылка
		|ИЗ
		|	Документ.ПолучениеДенег КАК ПолучениеДенег
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПолучениеДенег.МоментВремени УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВыплатаДенег.Ссылка
		|ИЗ
		|	Документ.ВыплатаДенег КАК ВыплатаДенег
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВыплатаДенег.МоментВремени УБЫВ;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПланированиеОказанияУслуг.Ссылка
		|ИЗ
		|	Документ.ПланированиеОказанияУслуг КАК ПланированиеОказанияУслуг
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПланированиеОказанияУслуг.МоментВремени УБЫВ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОказаниеУслугСервисМенеджером.Ссылка
		|ИЗ
		|	Документ.ОказаниеУслугСервисМенеджером КАК ОказаниеУслугСервисМенеджером
		|
		|УПОРЯДОЧИТЬ ПО
		|	ОказаниеУслугСервисМенеджером.МоментВремени УБЫВ";
	
	МассивРезультатовЗапроса = Запрос.ВыполнитьПакет();
	
	//--Поступления--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[0].Выбрать();
	
	Разница = 2;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Попытка
			
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
	
	//--Реализации--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[1].Выбрать();
	
	Разница = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Попытка
		
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
	
	//--Поступления денег--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[2].Выбрать();
	
	Разница = 3000;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Попытка
		
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
	
	//--Выплаты денег--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[3].Выбрать();
	
	Разница = 2000;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Попытка
		
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
	
	//--ПланированиеОказанияУслуг--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[4].Выбрать();
	
	Разница = 3000;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Для Каждого ТекСтрока Из ДокументОбъект.Состав Цикл
			
			ТекСтрока.ПланируемаяДатаВыполнения = ДокументОбъект.Дата;
			
		КонецЦикла;
		
		Попытка
		
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
	
	//--ОказаниеУслугСервисМенеджером--
	
	ВыборкаДетальныеЗаписи = МассивРезультатовЗапроса[5].Выбрать();
	
	Разница = 2000;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		ДокументОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ДокументОбъект.Дата = ТекМесяц - Разница;
		
		Для Каждого ТекСтрока Из ДокументОбъект.Состав Цикл
			
			ТекСтрока.ПланируемаяДатаВыполнения = ТекМесяц - Разница;
			
		КонецЦикла;

		Попытка
		
			Если ДокументОбъект.Проведен Тогда
				
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
			Иначе	
				ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
			КонецЕсли;
		
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "" + ОписаниеОшибки();
			Сообщение.Сообщить();
			
		КонецПопытки;
		
		Разница = Разница + 24*60*60*(12.3);
		
	КонецЦикла;
		


КонецПроцедуры

