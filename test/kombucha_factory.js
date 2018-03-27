const Kombucha = artifacts.require("Kombucha")
const KombuchaFactory = artifacts.require('KombuchaFactory')

contract('KombuchaFactory', () => {
    let kombuchaFactory

    before(async () => {
        kombuchaFactory = await KombuchaFactory.deployed()
    })

    it('makes useable Kombucha instances', async () => {
        const kombucha = await Kombucha.at((await kombuchaFactory.createKombucha('apple', 10, 10)).logs[0].args.kombucha)
        assert.equal(await kombucha.flavor(), 'apple')
        assert.equal(await kombucha.capacity(), 10)
        assert.equal(await kombucha.fillAmount(), 10)
        await kombucha.drink(5)
        assert.equal(await kombucha.fillAmount(), 5)
        await kombucha.fill(2)
        assert.equal(await kombucha.fillAmount(), 7)
    })
})