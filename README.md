# 🍕 TestDelivery
**TestDelivery App** — это iOS-приложение, разработанное на **UIKit**, которое отображает меню еды с категориями и позициями. Приложение построено с акцентом на **чистую архитектуру**, модульность и **разделение ответственности** (Separation of Concerns), без использования сторонних библиотек.

---

## 📸 Скриншоты

<img src="Screenshots/menu_screen.png" width="300"> <img src="Screenshots/auth_screen.png" width="300">

---

## ⚙️ Функциональность

- 📦 Загрузка меню из API (с категорией и блюдами)
- 🖼 Асинхронная загрузка изображений
- ♻️ Кэширование изображений через `NSCache`
- 🔁 Обновление UI при выборе категории
- 📐 Использование `UICollectionView` с секциями и кастомными хедерами
- ✅ Поддержка переиспользования ячеек без "прыгающих" картинок
- ❌ Без сторонних зависимостей — только `Foundation` и `UIKit`

---

## 🧩 Архитектура

Проект следует принципам **чистой архитектуры**:

- **NetworkManager** — отвечает за загрузку JSON-данных
- **ImageLoader** — фасад для загрузки и кэширования изображений
- **ImageNetworkManager** — загружает изображения из сети
- **ImageCacheManager** — кэширует изображения через `NSCache`
- **View + Presenter/Model** — обработка бизнес-логики отделена от UI


## 🔧 Установка и запуск

1. Склонируй репозиторий:

```bash
git clone https://github.com/your-username/testDelivery.git

2. Открой .xcodeproj в Xcode:
cd testDelivery
open TestDelivery.xcodeproj


## API

Приложение использует открытый API:
https://free-food-menus-api-two.vercel.app/all

Пример возвращаемого объекта:
[
  {
    "id": 1,
    "name": "Pepperoni Pizza",
    "dsc": "Hot pizza with extra cheese",
    "price": 499,
    "img": "https://example.com/pizza.jpg",
    "category": "pizza"
  }
]

