
Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.ЗаказыПоставщикам.Записывать = Истина;
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ЗаказыПоставщикам.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.ЗаказПоставщику = Ссылка;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
	КонецЦикла;

КонецПроцедуры
