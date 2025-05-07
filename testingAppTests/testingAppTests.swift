//
//  testingAppTests.swift
//  testingAppTests
//
//  Created by Rama Adi Nugraha on 07/05/25.
//

import Testing
@testable import testingApp

struct testingAppTests {

    // Dokumentasi swift testing:
    // https://developer.apple.com/xcode/swift-testing/
    @Test func recipeListViewModel() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        // Contoh testing untuk RecipeListViewModel
        
        // Gunakan fake service untuk menghindari dependensi pada jaringan
        // Ini tidak akan memanggil API asli, dan apabila data live berubah,
        // tidak akan mempengaruhi hasil test
        let recipeService = FakeRecipeService()
        let viewModel = RecipeListViewModel(recipeService: recipeService)
        
        // Simulasi ambil resep
        // (biasanya dipanggil oleh view tapi di sini kita panggil secara langsung)
        await viewModel.fetchRecipes()
        
        // Sampel 1 resep untuk dilihat apakah sudah benar
        // Fake recipe pasti akan selalu menampilkan 1 resep ini karena pada file dummy-recipes.json
        // Posisi 0 adalah "Classic Margherita Pizza"
        #expect(viewModel.recipes.first?.name == "Classic Margherita Pizza")
    }

}
